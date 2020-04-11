defmodule Rumbl.Accounts do
  @moduledoc """
  The accounts context
  """

  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  @doc """
  list all users
  """
  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end
end