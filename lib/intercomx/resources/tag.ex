require Logger

defmodule IntercomX.Tag do
  use IntercomX.Client

  def create(params) when is_map(params) do
    with {:ok, res} <- post("/tags", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def deleteRequest(id) when is_bitstring(id) do
    with {:ok, res} <- delete("/tags/" <> id) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end
end
