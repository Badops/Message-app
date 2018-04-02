defmodule MessageApp.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :attach_file, :string
      add :from, references(:users, on_delete: :nothing)
      add :to, references(:users, on_delete: :nothing)

      timestamps()
    end

  end
end
