defmodule NurseTestWeb.PageController do
  use NurseTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
