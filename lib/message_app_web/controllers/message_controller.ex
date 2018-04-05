defmodule MessageAppWeb.MessageController do
	use MessageAppWeb, :controller
	
	alias MessageApp.Messages.Message
	alias MessageApp.Messages
	alias MessageApp.Accounts.User
	alias MessageApp.Accounts


	def index(conn, %{"user" => username}) do
		case Accounts.get_user_by_username(username) do
			%User{} -> 
				messages = Messages.get_user_messages(username)
				render(conn, "index.html", messages: messages)
			
			nil -> # in case the user record is not found in the database
				conn
				|> put_flash(:info, "You are not registered.")
				|> redirect(to: "/users/new")
			
			_ -> 
				conn 
				|> redirect(to: "/")
		end
	end

  def new(conn, params) do
		changeset = Message.changeset(%Message{}, params)
		render conn, changeset: changeset
	end
	
	# This function is called when a file is added as an attachment to the message
	def create(conn, %{"message" => message_params = %{"attach_file" => _attach_file}}) do
		update_map = message_params	
									|> Map.put("content_type", 
												message_params["attach_file"].content_type)

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

	# This function is called when a message is sent without an attachment
	def create(conn, %{"message" => message_params}) do
		case Messages.create_message(message_params) do
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

	# This action is performed when a user wants to download attachment
	def download(conn, %{"message_id" => id}) do
		message = MessageApp.Messages.get_message!(id)
		conn
    |> put_resp_header(
      "content-disposition",
      ~s(attachment; filename="#{message.attach_file.file_name}")
    )
    |> put_resp_header("content-type", "#{message.content_type}")
    |> send_file(:ok, "#{Path.expand("./uploads")}/#{message.attach_file.file_name}")
	end
end




