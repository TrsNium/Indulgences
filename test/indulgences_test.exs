defmodule IndulgencesTest do
  use ExUnit.Case
  doctest Indulgences

  test "greets the world" do
    assert Indulgences.hello() == :world
  end

  test "scenario" do
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
    Indulgences.Engine.exute_scenario(test_scenario)
  end

  test "request_option update headers" do
    test_request_option =  %Indulgences.Http.RequestOptions{headers: [{"hoge", "huga"}]}
    desired1 = %Indulgences.Http.RequestOptions{headers: [{"hoge", "hugahuga"}]}
    desired2 = %Indulgences.Http.RequestOptions{headers: [{"hoge", "huga"}, {"huga", "hoge"}]}

    assert Indulgences.Http.RequestOptions.update_header(test_request_option, "hoge", "hugahuga") == desired1
    assert Indulgences.Http.RequestOptions.update_header(test_request_option, "huga", "hoge") == desired2
  end
end
