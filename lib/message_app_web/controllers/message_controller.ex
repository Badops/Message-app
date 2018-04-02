defmodule MessageAppWeb.MessageController do
	use MessageAppWeb, :controller
	# alias MessageApp.Accounts.User
	alias MessageApp.Accounts
	alias MessageApp.Messages.Message
	alias MessageApp.Messages


	# def index(conn, ) do
		# users = Accounts.list_users()
    # render(conn, "index.html", users: users)
	# end

  def new(conn, params) do
		changeset = Message.changeset(%Message{}, params)
		render conn, changeset: changeset
	end
	
	def create(conn, %{"message" => message_params}) do
		update_map = replace_username_with_id(message_params)
		case Messages.create_message(update_map) do
			{:ok, _changeset} -> 
				conn
				|> put_flash(:info, "Message Sent")
				|> redirect(to: "/")

			{:error, changeset} ->
				conn
				|> put_flash(:info, "Message not sent")
				|> render("new.html", changeset: changeset)
		end
	end

	defp get_users(message_params) do
		sender = message_params["from"]
						|> String.downcase()
						|> Accounts.get_user_by_username()

		receipient = message_params["to"]
								|> String.downcase()
								|> Accounts.get_user_by_username()
											
		{sender, receipient}
	end

	defp replace_username_with_id(message_params) do
		{sender, receipient} = get_users(message_params)
		updated_message_params = 
							message_params
							|> Map.put("from", sender.id)
							|> Map.put("to", receipient.id)

		updated_message_params
	end
end




