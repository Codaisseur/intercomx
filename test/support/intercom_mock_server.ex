require Logger

defmodule Intercom.MockServer do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  get "/users" do
    success(conn, fixture("all_users"))
  end

  def fixture(resource) do
    data = File.read!(Path.expand(__ENV__.file <> "/../fixtures/" <> resource <> ".json"))
    Poison.decode!(data)
  end

  defp success(conn, body) do
    conn
    |> Plug.Conn.send_resp(200, Poison.encode!(body))
  end

  defp created(conn, body) do
    conn
    |> Plug.Conn.send_resp(201, Poison.encode!(body))
  end

  defp not_found(conn) do
    conn
    |> Plug.Conn.send_resp(404, Poison.encode!(%{message: "not found"}))
  end

  defp failure(conn) do
    conn
    |> Plug.Conn.send_resp(422, Poison.encode!(%{message: "error message"}))
  end
end
