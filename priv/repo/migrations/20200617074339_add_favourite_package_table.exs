defmodule Hexpm.RepoBase.Migrations.AddFavouritePackageTable do
  use Ecto.Migration

  def up() do
    execute("""
      CREATE TABLE favourite_packages (
        id serial PRIMARY KEY,
        user_id integer REFERENCES users,
        package_id integer REFERENCES packages,

        updated_at timestamp,
        inserted_at timestamp
      )
    """)
  end

  def drop() do
    execute("DROP TABLE IF EXISTS favourite_packages")
  end
end
