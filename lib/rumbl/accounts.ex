defmodule Rumbl.Accounts do
  @moduledoc """
  The accounts context
  """

  alias Rumbl.Accounts.User

  @doc """
  list all users
  """
  def list_users do
    [
      %User{id: "1", name: "Lee", username: "lmsutton"},
      %User{id: "2", name: "Ali", username: "whitealisonc"}
    ]
  end

  def get_user(id) do
    Enum.find(list_users(), fn map -> map.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn map -> 
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end) end)
  end
end
