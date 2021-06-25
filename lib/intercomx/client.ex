defmodule IntercomX.Client do
  @moduledoc false
  defmacro __using__(_) do
    quote do
      use HTTPoison.Base

      @content_type "application/json"

      def endpoint, do: Application.get_env(:intercomx, :endpoint, "https://api.intercom.io")

      def process_url(path) do
        endpoint() <> path
      end

      def process_request_headers(headers) when is_map(headers) do
        Enum.into(headers, [])
        |> Keyword.merge(http_headers())
      end

      def process_request_headers(headers) do
        Keyword.merge(headers, http_headers())
      end

      def process_request_body(body) do
        Poison.encode!(body)
      end

      def as_struct(data, _) when is_nil(data), do: nil

      def as_struct(data, type) when is_list(data) do
        Enum.map(data, fn d ->
          as_struct(d, type)
        end)
      end

      def as_struct(data, type) do
        struct(
          type,
          Enum.map(data, fn {k, v} ->
            {String.to_atom(k), v}
          end)
        )
      end

      def process_response(resp) do
        case resp do
          %{status_code: 200} ->
            resp

          %{status_code: 201} ->
            resp

          %{status_code: 204} ->
            resp

          %{status_code: 301} ->
            resp

          %{status_code: 404} ->
            raise IntercomX.NotFoundError

          %{status_code: 429} ->
            raise IntercomX.TooManyRequests

          %{body: body, status_code: 422} ->
            raise IntercomX.RequestError, Poison.decode!(body)

          resp ->
            raise IntercomX.ServerError
        end
      end

      defp http_headers do
        token = Application.get_env(:intercomx, :token)
        [
          Accept: @content_type,
          Authorization: "Bearer #{token}",
          "Content-Type": @content_type
        ]
      end

      def create_friendly_error(body) do
        Poison.decode!(body)
      end

      defp intercom_error(status, message) do
        # TODO: do some stuff
      end
    end
  end
end

defmodule IntercomX.NotFoundError do
  defexception message: "Intercom resource not found"
end

defmodule IntercomX.RequestError do
  defexception message: "Intercom request error"
end

defmodule IntercomX.ServerError do
  defexception message: "Intercom server error"
end

defmodule IntercomX.TooManyRequests do
  defexception message: "Intercom too many requests"
end
