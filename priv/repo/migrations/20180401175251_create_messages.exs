defmodule MessageApp.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :attach_file, :string
      add :content_type, :string
      add :from, :string
      add :to, :string

      timestamps()
    end

  end
end
