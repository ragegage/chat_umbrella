defmodule ChatWeb.UserTest do
  use ChatWeb.ModelCase

  alias ChatWeb.User

  @valid_attrs %{email: "some content", password_digest: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
