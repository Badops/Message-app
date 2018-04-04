defmodule MessageApp.Messages.Message do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  


  schema "messages" do
    field :message, :string
    field :attach_file, MessageApp.Messages.AttachFile.Type
    field :content_type, :string
    
    belongs_to :sender, MessageApp.Accounts.User, foreign_key: :from
    belongs_to :receiver, MessageApp.Accounts.User, foreign_key: :to

    timestamps()
  end

  @required_fields [:message, :from, :to]
  @optional_fields [:content_type]
  @attach_file_field [:attach_file]

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, @attach_file_field)
    |> validate_required(@required_fields)
  end
end
