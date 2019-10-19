defmodule IntercomX do
  @moduledoc """
  This is an unofficial [Intercom API](https://developers.intercom.com/) client. It uses HTTPoison for requests and Poison for dealing with JSON payloads.

  ## Installation

  The package can be installed by adding `intercomx` to your list of dependencies in `mix.exs`:

      def deps do
        [
          {:intercomx, "~> 0.1.1"}
        ]
      end

  ## Configuration

  First go to https://app.intercom.com/developers/_ and create an API token for **Personal Use**. Then configure intercomx to use your token:

      # config/config.exs

      config :intercomx,
        endpoint: "https://api.intercom.io/",
        token: "your-api-token"

  """
end
