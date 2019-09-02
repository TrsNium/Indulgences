defmodule IndulgencesTest do
  use ExUnit.Case
  doctest Indulgences

  test "greets the world" do
    assert Indulgences.hello() == :world
  end

  test "basic scenario execute engine " do
    test_scenario = Indulgences.Scenario.new("test_scenario",
      fn ->
        Indulgences.Http.get("http://www.google.com")
        |> Indulgences.Http.set_header("hoge", "huga")
        |> Indulgences.Http.check(
          fn(%HTTPoison.Response{}=response, %{}=state)->
            assert response.status_code == 200
            state
            |> Map.put(:body, response.body)
          end)
      end)
    Indulgences.Scenario.Engine.execute_scenario(test_scenario)
  end

  test "flexible scenario execute engine " do
    test_scenario = Indulgences.Scenario.new("test_scenario",
      fn ->
        Indulgences.Http.get("http://www.google.com")
        |> Indulgences.Http.set_header("hoge", "huga")
        |> Indulgences.Http.check(
            fn(%HTTPoison.Response{}=response, %{}=state)->
              assert response.status_code == 200
              state
              |> Map.put(:body, response.body)
            end)
        |> Indulgences.Http.get("http://www.google.com")
        |> Indulgences.Http.set_header("key",
            fn(state)->
              Map.get(state, :body)
            end)
      end)
    Indulgences.Scenario.Engine.execute_scenario(test_scenario)
  end

  test "request_option update headers" do
    test_request_option =  %Indulgences.Http.RequestOptions{headers: [{"hoge", "huga"}]}
    desired1 = %Indulgences.Http.RequestOptions{headers: [{"hoge", "hugahuga"}]}
    desired2 = %Indulgences.Http.RequestOptions{headers: [{"hoge", "huga"}, {"huga", "hoge"}]}

    assert Indulgences.Http.RequestOptions.update_header(test_request_option, "hoge", "hugahuga") == desired1
    assert Indulgences.Http.RequestOptions.update_header(test_request_option, "huga", "hoge") == desired2
  end

  test "request_option_evaluter evalute option" do
    alias Indulgences.Http.RequestOptions.Evaluter
    alias Indulgences.Http.RequestOptions

    state = %{url: "test_url", value: "test_value"}
    request_option = %RequestOptions{}
                     |> Map.put(:url, fn(state) -> Map.get(state, :url) end)
                     |> Map.put(:headers, [{"key", fn(state) -> Map.get(state, :value) end}])
    desired_request_option = %RequestOptions{url: "test_url", headers: [{"key", "test_value"}]}

    evaluted_request_option = Evaluter.evalute_request_option(request_option, state)
    assert evaluted_request_option == desired_request_option
  end
end
