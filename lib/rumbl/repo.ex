defmodule Rumbl.Repo do
  @moduledoc """
    In memory repository.
  """

  def all(Rumbl.User) do
    [%Rumbl.User{id: "1", name: "Phil", username: "philalekseev", password: "elixir"},
    %Rumbl.User{id: "2", name: "Bob", username: "jimbob", password: "elixir"},
    %Rumbl.User{id: "3", name: "Jim", username: "bobjim", password: "elixir"}]
  end
  def all(_module), do: []

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

end
