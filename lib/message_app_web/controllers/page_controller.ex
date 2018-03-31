defmodule MessageAppWeb.PageController do
  use MessageAppWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
