defmodule IntercomX.UserTest do
  use IntercomX.ResponseCase
  alias IntercomX.User

  # doctest User
  describe "list" do
    test "returns all users" do
      assert User.list() === {:ok, fixture("all_users", User)}
    end
  end

end
