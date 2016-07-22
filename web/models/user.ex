defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true #not persisted to db
    field :password_hash, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), []) #check required fields and cast to schema types
    |> validate_length(:username, min: 1, max: 20)
  end
end
