defmodule Hexpm.RepoBase.Migrations.AddFavouritePackageTable do
  use Ecto.Migration

  def up() do
    create table(:favourite_packages) do
      add(:user_id, references(:users), null: false)
      add(:package_id, references(:packages), null: false)

      timestamps()
    end
  end

  def drop() do
    drop(table("favourite_packages"))
  end
end
