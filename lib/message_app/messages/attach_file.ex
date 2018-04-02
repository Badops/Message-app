defmodule MessageApp.Messages.AttachFile do
  use Arc.Definition
	use Arc.Ecto.Definition
	
  def __storage, do: Arc.Storage.Local
end