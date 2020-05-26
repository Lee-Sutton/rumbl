defmodule Rumble.AccountsTests do
  use Rumbl.DataCase, async: true
  alias Rumbl.Accounts

  describe "register_users/1" do
    @valid_attrs %{
      name: "User",
      username: "eva",
      password: "secret"
    }

    @invalid_attrs %{}

    test "valid data inserts user" do
      {:ok, user} = Accounts.register_user(@valid_attrs)
      assert user.id
      assert user.name == "User"
      assert user.username == "eva"
      assert user.password
      assert user.password_hash
    end

    test "invalid data does not insert user" do
      {:error, _} = Accounts.register_user(@invalid_attrs)

      assert Accounts.list_users() == []
    end

    test "enforce unique username" do
      {:ok, user} = Accounts.register_user(@valid_attrs)
      assert user.id

      {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{username: ["has already been taken"]} = errors_on(changeset)
      assert [user] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))

      {:error, changeset} = Accounts.register_user(attrs)
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
    end

    test "requires password to be at least 6 characters" do
      attrs = Map.put(@valid_attrs, :password, String.duplicate("a", 5))

      {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    @pass "123456"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} = Accounts.authenticate_by_username_and_pass(user.username, @pass)
      assert auth_user.id == user.id
    end

    test "returns anauthorized error for invalid password", %{user: user} do
      assert {:error, :unauthorized} = Accounts.authenticate_by_username_and_pass(user.username, "badpassword")
    end

    test "returns not found with no matching user" do
      assert {:error, :not_found} = Accounts.authenticate_by_username_and_pass("invalid", "badpassword")
    end
    
  end
end
