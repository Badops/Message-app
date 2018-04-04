defmodule MessageAppWeb.MessageController do
	use MessageAppWeb, :controller
	# alias MessageApp.Accounts.User
	alias MessageApp.Accounts
	alias MessageApp.Messages.Message
	alias MessageApp.Messages


	def index(conn, %{"user" => username}) do
		messages = Messages.get_user_messages(username)
		render(conn, "index.html", messages: messages)
	end

  def new(conn, params) do
		changeset = Message.changeset(%Message{}, params)
		render conn, changeset: changeset
	end
	
	def create(conn, %{"message" => message_params}) do
		IO.inspect message_params
		update_map = replace_username_with_id(message_params)
									|> Map.put("path", message_params["attach_file"].path)
									|> Map.put("content_type", message_params["attach_file"].content_type)
		
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

	def download(conn, params = %{"message_id" => id}) do
		message = MessageApp.Messages.get_message!(id)
		conn
    |> put_resp_header(
      "content-disposition",
      ~s(attachment; filename="#{message.attach_file.file_name}")
    )
    |> put_resp_header("content-type", "#{message.content_type}")
    |> send_file(:ok, "#{Path.expand("./uploads")}/#{message.attach_file.file_name}")
	end

	# "/tmp/plug-1522/multipart-1522708739-250234632823950-3
	
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




