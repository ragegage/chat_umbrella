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
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password)a, [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
  end
  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true,
                      changes: %{password: password}} ->
        put_change(changeset,
                    :password_digest,
                    Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
