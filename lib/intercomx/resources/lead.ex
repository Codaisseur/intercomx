require Logger

defmodule IntercomX.Lead do
  use IntercomX.Client

  @doc """
  Create / update a Lead

  ## Parameters
  * `type`, `String` - Value is `contact`
  * `id`, `String` - The Intercom defined id representing the Lead
  * `created_at`, `Timestamp` - The time the Lead was added to Intercom
  * `updated_at`, `Timestamp` - The last time the Lead was updated
  * `user_id`, `String` - Automatically generated identifier for the Lead
  * `email`, `String` - The email you have defined for the Lead
  * `phone`, `String` - The phone number you have defined for the lead
  * `name`, `String` - The name of the Lead
  * `custom_attributes`, 'String' - The custom attributes you have set on the Lead
  * `last_request_at`, `Timestamp` - The time the Lead last recorded making a request
  * `avatar`, `Object` - An avatar object for the Lead
  * `unsubscribed_from_email`, `Boolean` - Whether the Lead is unsubscribed from emails
  * `location_data`, `Object` - A Location Object relating to the Lead
  * `companies`, `List` - A list of companies for the Lead
  * `social_profiles`, `List` - A list of social profiles associated with the Lead
  * `segments`, `List` - A list of segments the Lead.
  * `tags`, `List` - A list of tags associated with the Lead.
  * `referrer`, `String` - 	The URL of the page the lead was last on
  * `utm_source`, `String` - Identifies which site sent the traffic
  * `utm_medium`, `String` - Identifies what type of link was used
  * `utm_campaign`, `String` - Identifies a specific product promotion or strategic campaign
  * `utm_term`, `String` - Identifies search terms
  * `utm_content`, `String` - Identifies what specifically was clicked to bring the user to the site

  ## Social Profiles
  * `type`, `String` - Value is 'social_profile'
  * `name`, `String` - The name of the service (e.g., twitter, facebook)
  * `username`, `String` - User name or handle on the service
  * `url, `String` - The user homepage on the service
  * `id`, `String` - Optional. User ID on the service

  ## Avatar
  * `type`, `String` - Value is 'avatar'
  * `image_url`, `String` - An avatar image URL. note: the image url needs to be https

  ## Location
  Note: Location data is read only and can not be updated via the API.

  * `type`, `String` - Value is 'location_data'
  * `city_name`, `String` - Optional. A city name
  * `continent_code`, `String` - Optional. A continent code
  * `country_code`, `String` - Optional. An ISO 3166 country code
  * `country_name`, `String` - Optional. The country name
  * `latitude`, `Number` - Optional. The latitude
  * `longitude`, `Number` - Optional. The longitude
  * `postal_code`, `String` - Optional. A postal code
  * `region_name`, `String` - Optional. A region name
  * `timezone`, `String` - Optional. An ISO 8601 timezone

  ## Example
  IntercomX.Lead.create(%{ email: "danny@codaisseur.com" })
  """

  def update(params) when is_map(params) do
    create(params)
  end

  def create(params) when is_map(params) do
    with {:ok, res} <- post("/contacts", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Get a specific lead

  ## Default
  * `id`, `String` - the value of the lead's id field

  ## Parameters
  * `user_id`, `String` - The user id intercom has automatically defined for the lead
  * `phone`, `String` - The phone number defined for the user

  ## Example
  IntercomX.Lead.find("5dad68c7d0d83522108d7b40")
  IntercomX.Lead.find(%{user_id: "d5af2cec-2a4b-4aec-8aed-43410799757f"})
  """
  def find(id) when is_bitstring(id) do
    with {:ok, res} <- get("/contacts/" <> id) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  def find(params) when is_map(params) do
    queryString = params
    |> Map.keys()
    |> Enum.reduce("?", fn opt, qs ->
      qs <> "#{opt}=#{params[opt]}&"
    |> String.slice(0..-2)
    end)

    with {:ok, res} <- get("/contacts" <> queryString) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  List all the leads, sorted by created_at (desc)

  ## Parameters
  * `page`, `Interger` - what page of results to fetch defaults to first page.
  * `per_page`, `Interger` - how many results per page defaults to 50, max is 60.
  * `order`, `String` - `asc` or `desc`. Return the users in ascending or descending order. defaults to desc.
  * `sort`, `String` - what field to sort the results by. Valid values: `created_at`, `last_request_at`, `signed_up_at`, `updated_at`
  * `created_since`, `Interger` - limit results to users that were created in that last number of days.

  ## Example
  IntercomX.Lead.list(%{page: 2})
  """
  def list(params) when is_map(params) do
    with {:ok, res} <- get("/contacts", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  List by email or phone

  ## Parameters
  * `email`, `String` - The email of the lead
  * `phone`, `Interger` - The phone of the lead
  * `page`, `Interger` - what page of results to fetch defaults to first page.
  * `per_page`, `Interger` - how many results per page defaults to 50, max is 60.

  ## Example
  IntercomX.Lead.listByEmail(%{email: "danny@codaisseur.com"})
  """
  def listBy(params) when is_map(params) do
    queryString = params
      |> Map.keys()
      |> Enum.reduce("?", fn opt, qs ->
        qs <> "#{opt}=#{params[opt]}&"
      |> String.slice(0..-2)
      end)

    with {:ok, res} <- get("/contacts?email=" <> queryString) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Delete a Lead

  ## Parameters
  * `id`, `String` - The id of the lead
  * `user_id`, `String` - The user_id of the lead

  ## Example
  IntercomX.Lead.delete("5dad68c7d0d83522108d7b40") // id
  IntercomX.Lead.delete("d5af2cec-2a4b-4aec-8aed-43410799757f") // user_id
  """
  def deleteRequest(id) when is_bitstring(id) do
    with {:ok, res} <- delete("/contacts/" <> id) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Convert a Lead into a User

  Leads can be converted to Users. This is done by passing both Lead and User identifiers. If the User exists, then the Lead will be merged into it, the Lead deleted and the User returned. If the User does not exist, the Lead will be converted to a User, with the User identifiers replacing it's Lead identifiers.
  Identifiers (id, user_id, email) from Leads are never added onto Users with a merge.
  A Lead's email, but not user_id is retained when converting a Lead to a new User.

  ## Parameters
  Note: Contacts are the same as Leads (they partly changed names)

  User:
  * `user.id`, `String` - The id of the User
  * `user.user_id`, `String` - The user_id of the User
  * `user.email`, `String` - The email of the User

  Contact / Lead:
  * `contact.id`, `String` - The id of the Lead
  * `contact.user_id`, `String` - The user_id of the Lead

  ## Example
  IntercomX.Lead.convert(%{ user: %{ user_id: "1000009" }, contact: %{ user_id: "6f39348e-4b19-4b37-8555-8b2e526025a4" } })
  """
  def convert(params) when is_map(params) do
    with {:ok, res} <- post("/contacts/convert", params) do
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
