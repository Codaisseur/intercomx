# TODO: add https://developers.intercom.com/intercom-api-reference/reference#companies-and-users
require Logger

defmodule IntercomX.Company do
  use IntercomX.Client

  @doc """
  Create / update an Company

  ## Parameters
  * `remote_created_at`, `timestamp` - The time the company was created by you
  * `company_id`, `String` - (Required) The company id you have defined for the company
  * `name`, `String` - (Required) The name of the company
  * `monthly_spend`, `Integer` - How much revenue the company generates for your business. Note that this will truncate floats. i.e. it only allow for whole integers, 155.98 will be truncated to 155. Note that this has an upper limit of 2**31-1 or 2147483647.
  * `plan`, `String` - The name of the plan you have associated with the company
  * `size`, `Integer` - The number of employees in this company
  * `website`, `Integer` - The URL for this company's website. Please note that the value specified here is not validated. Accepts any string.
  * `industry`, `String` - The industry that this company operates in
  * `custom_attributes`, `Object` - A hash of key/value pairs containing any other data about the company you want Intercom to store.

  ## Example
  iex> IntercomX.Company.create(%{:name =>  "Elixir Inc.", :company_id => "5"})

  """
  def update(params) when is_map(params) do
    create(params)
  end
  def create(params) when is_map(params) do
    with {:ok, res} <- post("/companies", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
    List companies

    ## Parameters
    * `page`, `Interger` - What page of results to fetch, defaults to first page.
    * `per_page`, `Interger` - How many results per page, defaults to 50.
    * `order`, `String` - `asc` or `desc` Return the companies in ascending or descending order, defaults to desc.

    ## Example
    iex> IntercomX.Company.list(%{page: 2})
  """
  def list(params \\ %{}) do
    with {:ok, res} <- get("/companies", params) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Find a Company by company_id or name

  ## Default
  * `id`, `String` -> Value of the company's `id` field

  ## With parameters
  * `company_id`, `String` - The company id you have given to the company
  * `name`, `String` - The name of the company

  ## Example
  iex> IntercomX.Company.find("234234sdf") // by id
  iex> IntercomX.Company.find(%{company_id: "6"}) // by params
  """
  def find(id) when is_bitstring(id) do
    with {:ok, res} <- get("/companies/" <> id) do
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

    with {:ok, res} <- get("/companies" <> queryString) do
      {:ok, res.body}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  List Company users

  ## Parameters
  * `company_id`, `String` - (Required) Your company id, example: "5da99211909121c6fff7aacd"
  * `type`, `???` - (Required) The value must be user

  ## Example
  iex> IntercomX.Company.listUsers(%{:company_id =>  "5da99211909121c6fff7aacd", :type => "user"})
  """
  def listUsers(params) when is_map(params) do
    with {:ok, res} <- get("/companies/" <> params[:company_id] <> "/users", %{type: params[:type]}) do
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
