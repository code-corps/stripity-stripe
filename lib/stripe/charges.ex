defmodule Stripe.Charges do
  @moduledoc """
  Functions for working with charges at Stripe. Through this API you can:

    * create a charge,
    * update a charge,
    * get a charge,
    * list charges,
    * count charges,
    * refund a charge,
    * partially refund a charge.

  Stripe API reference: https://stripe.com/docs/api#charges
  """

  @endpoint "charges"

  @doc """
  Create a charge.

  Creates a charge for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, charge}` tuple.

  ## Examples

      params = [
        source: [
          object: "card",
          number: "4111111111111111",
          exp_month: 10,
          exp_year: 2020,
          country: "US",
          name: "Ducky Test",
          cvc: 123
        ],
        description: "1000 Widgets"
      ]

      {:ok, charge} = Stripe.Charges.create(1000, params)

  """
  def create(amount, params) do
    create amount, params, Stripe.config_or_env_key
  end

  @doc """
  Create a charge. Accepts Stripe API key.

  Creates a charge for a customer or card using amount and params. `params`
  must include a source.

  Returns `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.create(1000, params, key)

  """
  def create(amount, params, key) do
    #default currency
    params = Keyword.put_new params, :currency, "USD"
    #drop in the amount
    params = Keyword.put_new params, :amount, amount

    Stripe.make_request_with_key(:post, @endpoint, key, params)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Get a list of charges.

  Gets a list of charges.

  Accepts the following parameters:

    * `limit` - a limit of items to be returned (optional; defaults to 10).

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = Stripe.charges.list() # Get a list of 10 charges
      {:ok, charges} = Stripe.charges.list(20) # Get a list of 20 charges

  """
  def list(params \\ [])
  def list(limit) when is_integer(limit) do
    list Stripe.config_or_env_key, limit
  end
  @doc """
  Get a list of charges.

  Gets a list of charges.

  Accepts the following parameters:

    * `params` - a list of params supported by Stripe (optional; defaults to []). Available parameters are:
      `customer`, `ending_before`, `limit` and `source`.

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = Stripe.Charges.list(source: "card") # Get a list of charges for cards

  """
  def list(params) do
    list(Stripe.config_or_env_key, params)
  end

  @doc """
  Get a list of charges. Accepts Stripe API key.

  Gets a list of charges.

  Accepts the following parameters:

    * `limit` - a limit of items to be returned (optional; defaults to 10).

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = Stripe.charges.list("my_key") # Get a list of up to 10 charges
      {:ok, charges} = Stripe.charges.list("my_key", 20) # Get a list of up to 20 charges

  """
  def list(key, limit) when is_integer(limit) do
    Stripe.make_request_with_key(:get, "#{@endpoint}?limit=#{limit}", key)
    |> Stripe.Util.handle_stripe_response
  end
  @doc """
  Get a list of charges. Accepts Stripe API key.

  Gets a list of charges.

  Accepts the following parameters:

    * `params` - a list of params supported by Stripe (optional; defaults to
      `[]`). Available parameters are: `customer`, `ending_before`, `limit` and
      `source`.

  Returns a `{:ok, charges}` tuple, where `charges` is a list of charges.

  ## Examples

      {:ok, charges} = Stripe.Charges.list("my_key", source: "card") # Get a list of charges for cards

  """
  def list(key, params) do
    Stripe.make_request_with_key(:get, "#{@endpoint}", key, %{}, %{}, [params: params])
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Update a charge.

  Updates a charge with changeable information.

  Accepts the following parameters:

    * `params` - a list of params to be updated (optional; defaults to `[]`).
      Available parameters are: `description`, `metadata`, `receipt_email`,
      `fraud_details` and `shipping`.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      params = [
        description: "Changed charge"
      ]

      {:ok, charge} = Stripe.Charges.change("charge_id", params)

  """
  def change(id, params) do
    change id, params, Stripe.config_or_env_key
  end

  @doc """
  Update a charge. Accepts Stripe API key.

  Updates a charge with changeable information.

  Accepts the following parameters:

    * `params` - a list of params to be updated (optional; defaults to `[]`).
      Available parameters are: `description`, `metadata`, `receipt_email`,
      `fraud_details` and `shipping`.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      params = [
        description: "Changed charge"
      ]

      {:ok, charge} = Stripe.Charges.change("charge_id", params, "my_key")

  """
  def change(id, params, key) do
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{id}", key, params)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Capture a charge.

  Captures a charge that is currently pending.

  Note: you can default a charge to be automatically captured by setting `capture: true` in the charge create params.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.capture("charge_id")

  """
  def capture(id) do
    capture id, Stripe.config_or_env_key
  end

  @doc """
  Capture a charge. Accepts Stripe API key.

  Captures a charge that is currently pending.

  Note: you can default a charge to be automatically captured by setting `capture: true` in the charge create params.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.capture("charge_id", "my_key")

  """
  def capture(id,key) do
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{id}/capture", key)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Get a charge.

  Gets a charge.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.get("charge_id")

  """
  def get(id) do
    get id, Stripe.config_or_env_key
  end

  @doc """
  Get a charge. Accepts Stripe API key.

  Gets a charge.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.get("charge_id", "my_key")

  """
  def get(id, key) do
    Stripe.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Refund a charge.

  Refunds a charge completely.

  Note: use `refund_partial` if you just want to perform a partial refund.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.refund("charge_id")

  """
  def refund(id) do
    refund id, Stripe.config_or_env_key, %{}
  end

  @doc """
  Refunds a charge and reverses transfer to connected accounts.

  Return a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.refund_with_reversal("charge_id")
  """
  def refund_with_reversal(id) do
    refund id, Stripe.config_or_env_key, %{reverse_transfer: true, refund_application_fee: true}
  end


  @doc """
  Refund a charge. Accepts Stripe API key.

  Refunds a charge completely.

  Note: use `refund_partial` if you just want to perform a partial refund.

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.refund("charge_id", "my_key")

  """
  def refund(id, key, params) do
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{id}/refunds", key, params)
    |> Stripe.Util.handle_stripe_response
  end


  @doc """
  Partially refund a charge.

  Refunds a charge partially.

  Accepts the following parameters:

    * `amount` - amount to be refunded (required).

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.refund_partial("charge_id", 500)

  """
  def refund_partial(id, amount) do
    refund_partial id, amount, Stripe.config_or_env_key
  end

  @doc """
  Partially refund a charge. Accepts Stripe API key.

  Refunds a charge partially.

  Accepts the following parameters:

    * `amount` - amount to be refunded (required).

  Returns a `{:ok, charge}` tuple.

  ## Examples

      {:ok, charge} = Stripe.Charges.refund_partial("charge_id", 500, "my_key")

  """
  def refund_partial(id, amount, key) do
    params = [amount: amount]
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{id}/refunds", key, params)
    |> Stripe.Util.handle_stripe_response
  end

  @doc """
  Get total number of charges.

  Gets total number of charges.

  Returns `{:ok, count}` tuple.

  ## Examples

      {:ok, count} = Stripe.Charges.count()

  """
  def count do
    count Stripe.config_or_env_key
  end

  @doc """
  Get total number of charges. Accepts Stripe API key.

  Gets total number of charges.

  Returns `{:ok, count}` tuple.

  ## Examples

      {:ok, count} = Stripe.Charges.count("key")

  """
  def count(key) do
    Stripe.Util.count "#{@endpoint}", key
  end
end
