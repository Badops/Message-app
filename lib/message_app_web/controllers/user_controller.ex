defmodule MessageAppWeb.UserController do
	use MessageAppWeb, :controller
	alias MessageApp.Accounts.User
	alias MessageApp.Accounts

	def index(conn, _params) do
		users = Accounts.list_users()
    render(conn, "index.html", users: users)
	end

  def new(conn, params) do
		changeset = User.changeset(%User{}, params)
		render conn, changeset: changeset
	end
	
	def create(conn, %{"user" => user_params}) do
		case Accounts.create_user(user_params) do
			{:ok, _changeset} -> 
				conn
				|> put_flash(:info, "You are now registered")
				|> redirect(to: "/")

			{:error, changeset} ->
				conn
				|> put_flash(:info, "Unable to register")
				|> render("new.html", changeset: changeset)
		end
	end




end