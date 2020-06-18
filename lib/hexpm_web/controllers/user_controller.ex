defmodule HexpmWeb.UserController do
  use HexpmWeb, :controller

  def show(conn, %{"username" => username}) do
    user = Users.get_by_username(username, [:emails, :organization, owned_packages: :repository])

    if user do
      organization = user.organization

      case conn.path_info do
        ["users" | _] when not is_nil(organization) ->
          redirect(conn, to: Router.user_path(user))

        ["orgs" | _] when is_nil(organization) ->
          redirect(conn, to: Router.user_path(user))

        _ ->
          show_user(conn, user)
      end
    else
      not_found(conn)
    end
  end

  def toggle_follow(conn, %{"package" => package_name, "repository" => repository}) do
    user = conn.assigns.current_user
    current_favourite = FavouritePackages.get_by_username(user.username)
    package = Packages.get(repository, package_name)

    match = Enum.find(current_favourite, False, fn f -> f.package.id == package.id end)

    if match != False do
      Users.remove_favourite_package(match)
    else
      Users.add_favourite_package(%FavouritePackage{:user => user, :package => package})
    end
    
    conn
        |> put_flash(:info, "Favourite packages changed")
        |> redirect(to: Routes.user_path(HexpmWeb.Endpoint, :show, conn.assigns.current_user))
  end

  defp show_user(conn, user) do
    owned_packages =
      Packages.accessible_user_owned_packages(user, conn.assigns.current_user)
      |> Packages.attach_versions()

    public_email = User.email(user, :public)
    gravatar_email = User.email(user, :gravatar)

    favourite_packages = 
      FavouritePackages.get_by_username(user.username)
    
    render(
      conn,
      "show.html",
      title: user.username,
      container: "container page user",
      user: user,
      owned_packages: owned_packages,
      favourite_packages: favourite_packages,
      public_email: public_email,
      gravatar_email: gravatar_email
    )
  end
end
