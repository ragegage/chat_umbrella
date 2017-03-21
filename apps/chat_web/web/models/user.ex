defmodule ChatWeb.User do
  use ChatWeb.Web, :model

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(email)a
  @optional_fields ~w()a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password_digest])
    |> validate_required([:email, :password_digest])
  end
end
