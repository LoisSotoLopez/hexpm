defmodule Hexpm.Repository.FavouritePackage do
  use Hexpm.Schema

  schema "favourite_packages" do
    belongs_to :user, User
    belongs_to :package, Package

    timestamps()
  end

  def get(favourite) do
    from(
      f in FavouritePackage,
      where: f.id == ^favourite,
      select: f
    )
  end

  def get_by_username(username) do
    from(
      f in FavouritePackage,
      join: u in assoc(f, :user),
      join: p in assoc(f, :package),
      join: r in assoc(p, :repository),
      preload: [package: {p, repository: r}],
      where: u.username == ^username,
      select: f
    )
  end
end
