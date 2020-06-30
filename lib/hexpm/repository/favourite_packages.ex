defmodule Hexpm.Repository.FavouritePackages do
  use Hexpm.Context

  def get_by_username(username) do
    FavouritePackage.get_by_username(username)
    |> Repo.all()
  end
end
