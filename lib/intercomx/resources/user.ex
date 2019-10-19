require Logger

defmodule IntercomX.User do
  use IntercomX.Client

  @doc """
  Documentation: https://developers.intercom.com/intercom-api-reference/reference#create-or-update-user

  ## Parameters
  * `user_id`, `String` - (Required if no emial is supplied) A unique string identifier for the user. It is required on creation if an email is not supplied.
  * `email`, `String` - (Required if no user_id is supplied) The user's email address. It is required on creation if a user_id is not supplied.
  * `phone`, `String` - The user's phone number.
  * `id`, `String` - The id may be used for user updates.
  * `signed_up_at`, `String` - The time the user signed up
  * `name`, `String` - The user's full name
  * `custom_attributes`, `Map` - A hash of key/value pairs to represent custom data you want to attribute to a user. The key must be an existing Data Attribute.
  * `companies`, `Array` -  Identifies the companies this user belongs to.
  * `last_request_at`, `String` - A UNIX timestamp (in seconds) representing the date the user last visited your application.
  * `unsubscribed_from_emails`, `Boolean` - A boolean value representing the users unsubscribed status. default value if not sent is false.
  * `update_last_request_at`, `Boolean` - A boolean value, which if true, instructs Intercom to update the users' last_request_at value to the current API service time in UTC. default value if not sent is false.
  * `new_session`, `Boolean` - A boolean value, which if true, instructs Intercom to register the request as a session.

  ## Example
  iex> IntercomX.User.create(%{user_id => "20", name =>  "Elix Map"})

  """
  def update(params) when is_map(params) do
    create(params)
  end
  def create(params) when is_map(params) do
    with {:ok, res} <- post("/users", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  List all the users. The user list is sorted by the created_at field and by default is ordered descending, most recently created first.

  ## Parameters
  * `page`, `Interger` - what page of results to fetch defaults to first page.
  * `per_page`, `Interger` - how many results per page defaults to 50, max is 60.
  * `order`, `String` - asc or desc. Return the users in ascending or descending order, defaults to desc.
  * `sort`, `String` - what field to sort the results by. Valid values: created_at, last_request_at, signed_up_at, updated_at,
  * `created_since`, `String` - limit results to users that were created in that last number of days.

  ## Example
  iex> IntercomX.User.list()
  iex> IntercomX.User.list(%{page: 1})
  """
  def list(params \\ %{}) do
    with {:ok, res} <- get("/users", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  List users by email to find all users with the same email address.

  ## Parameters
  * `page`, `Interger` - what page of results to fetch defaults to first page.
  * `per_page`, `Interger` - how many results per page defaults to 50, max is 60.

  ## Example
  iex> IntercomX.User.listByEmail(%{email: "signed@codaisseur.dev"})
  """
  def listByEmail(params) when is_map(params) do
    queryString = params
      |> Map.keys()
      |> Enum.reduce("?", fn opt, qs ->
        qs <> "#{opt}=#{params[opt]}&"
      |> String.slice(0..-2)
      end)

    with {:ok, res} <- get("/users" <> queryString) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Find an User by id, user_id or email

  ## Default
  * `id`, `String` - the value of the user's id field

  ## Parameters as map
  * `user_id`, `String` - The user id you have defined for the user
  * `email`, `String` - The email you have defined for the user

  ## Example
  iex> IntercomX.User.find("5d88be2a75daed4ad2cadccf") // by id
  iex> IntercomX.User.find(%{user_id: "ck0wei7ak001p0776yf1o62uu"}) // by params
  """
  def find(id) when is_bitstring(id) do
    with {:ok, res} <- get("/users/" <> id) do
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

    with {:ok, res} <- get("/users" <> queryString) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Archive an user by id, user_id or email

  ## Default
  * `id`, `String` - the user's id field

  ## Parameters as map
  * `email`, `String` - The email you have defined for the user
  * `user_id`, `String` - The user id you have defined for the user

  ## Example
  iex> IntercomX.User.archive("5d88be2a75daed4ad2cadccf") // By id
  iex> IntercomX.User.archive(%{user_id => "ck0wei7ak001p0776yf1o62uu"})
  """
  def archive(id) when is_bitstring(id) do
    with {:ok, res} <- get("/companies/" <> id) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end


  def archive(params) when is_map(params) do
    queryString = params
      |> Map.keys()
      |> Enum.reduce("?", fn opt, qs ->
        qs <> "#{opt}=#{params[opt]}&"
      |> String.slice(0..-2)
      end)

    with {:ok, res} <- delete("/users" <> queryString) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  User Delete Requests allow you to irrevocably remove data about a User.

  After creating a User Delete Request, the User’s data will be hard-deleted within 90 days. This deletion cannot be cancelled or reversed.

  ## Parameters
  * `intercom_user_id`, `String` - (Required) The internal ID of the User to irrevocably delete

  ## Example
  iex> IntercomX.User.deleteRequest("5d88be2a75daed4ad2cadccf")
  """
  def deleteRequest(id) when is_bitstring(id) do
    with {:ok, res} <- delete("/user_delete_requests/" <> id) do
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
