defmodule MessageAppWeb.MessageView do
  use MessageAppWeb, :view
  alias MessageApp.Accounts
  alias MessageApp.Messages.Message

  def username(%Message{from: from}) do
    user = Accounts.get_user!(from)
    user.username
  end
end
