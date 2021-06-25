require Logger

defmodule IntercomX.Note do
  use IntercomX.Client

  def create(params) when is_map(params) do
    with {:ok, res} <- post("/notes", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def process_response_body(body) do
    Poison.decode(body, keys: :atoms)
  end
end
