defmodule NurseTestWeb.TestController do
  use NurseTestWeb, :controller

  def index(conn, _params) do
    [{"status_code", status}] = :ets.lookup(:resp_config, "status_code")
    [{"header", {key, value}}] = :ets.lookup(:resp_config, "header")
    [{"body", body}] = :ets.lookup(:resp_config, "body")
    
    conn
    |> put_resp_header(key, value)
    |> send_resp(status, Jason.encode!(body))
  end

end
