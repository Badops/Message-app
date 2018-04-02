defmodule MessageApp.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset


  schema "messages" do
    field :message, :string
    
    belongs_to :sender, MessageApp.Accounts.User, foreign_key: :from
    belongs_to :receiver, MessageApp.Accounts.User, foreign_key: :to

    timestamps()
  end

  @required_fields [:message, :from, :to]
  @optional_fields []

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
