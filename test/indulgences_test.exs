defmodule IndulgencesTest do
  use ExUnit.Case
  doctest Indulgences

  test "greets the world" do
    assert Indulgences.hello() == :world
  end

  test "scenario" do
  end

  test "request_option update headers" do
    test_request_option =  %Indulgences.Http.RequestOptions{headers: [{"hoge", "huga"}]}
    desired1 = %Indulgences.Http.RequestOptions{headers: [{"hoge", "hugahuga"}]}
    desired2 = %Indulgences.Http.RequestOptions{headers: [{"hoge", "huga"}, {"huga", "hoge"}]}

    assert Indulgences.Http.RequestOptions.update_header(test_request_option, "hoge", "hugahuga") == desired1
    assert Indulgences.Http.RequestOptions.update_header(test_request_option, "huga", "hoge") == desired2
  end
end
