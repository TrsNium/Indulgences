# Indulgences
![badge](https://action-badges.now.sh/TrsNium/Indulgences?workflow=test)

**TODO: Add description**

## Usage

Basically you can use like following.
```elixir
Indulgences.Scenario.new("test_scenario",
  fn ->
    Indulgences.Http.new("Test Local Request")
    |> Indulgences.Http.get("http://localhost")
    |> Indulgences.Http.set_header("header", "value")
    |> Indulgences.Http.check(
        fn(%HTTPoison.Response{}=response, %{}=state)->
          Indulgences.Http.is_status(response, 200)
          state
          |> Map.put(:body, response.body)
        end)
    Indulgences.Http.new("Test Local Request2")
    |> Indulgences.Http.get("http://localhost")
    |> Indulgences.Http.set_header("set-header-body", fn(state)->Map.get(state, :body)end)
    |> Indulgences.Http.check(
        fn(%HTTPoison.Response{}=response)->
          Indulgences.Http.is_status(response, 200)
        end)
  end)
|> Indulgences.Scenario.inject(
  fn ->
    Indulgences.Activation.constant_users_per_sec(100, 10)
  end)
|> Indulgences.Simulation.start
```

When you wanna use indulgences on a module basis.
```elixir
defmodule Test do
  use Indulgences

  @impl true
  def scenario() do
    Indulgences.Http.new("Test Local Request")
    |> Indulgences.Http.get("https://localhost")
    |> Indulgences.Http.set_header("hoge", "huga")
    |> Indulgences.Http.check(
      fn(%HTTPoison.Response{}=response)->
        Indulgences.Http.is_status(response, 404)
      end)
  end

  @impl true
  def activation() do
    Indulgences.Activation.constant_users_per_sec(100, 10)
  end
end

Test.start
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `indulgences` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:indulgences, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/indulgences](https://hexdocs.pm/indulgences).

