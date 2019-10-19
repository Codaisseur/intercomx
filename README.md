# IntercomX
[![Coverage Status](https://coveralls.io/repos/github/Codaisseur/intercomx/badge.svg?branch=refs/heads/master)](https://coveralls.io/github/Codaisseur/intercomx?branch=refs/heads/master) [![Test Status](https://github.com/Codaisseur/intercomx/workflows/Run%20Tests/badge.svg)](https://github.com/Codaisseur/intercomx)

This is an unofficial [Intercom API](https://developers.intercom.com/intercom-api-reference/reference) client. It uses HTTPoison for requests and Poison for dealing with JSON payloads.

## Installation

The package can be installed by adding `intercomx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:intercomx, "~> 0.1.1"}
  ]
end
```

## Configuration

First go to https://developers.intercom.com/building-apps/docs/authentication-types#section-access-tokens and follow the documentation to generate your access token. Then configure IntercomX to use your token:

```elixir
# config/config.exs

config :intercomx,
  endpoint: "https://api.intercom.io/",
  token: "your-api-token"
```