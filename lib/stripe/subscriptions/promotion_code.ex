defmodule Stripe.PromotionCode do
  @moduledoc """
  Work with Stripe promotion code objects.

  You can:

  - Create a promotion code
  - Retrieve a promotion code
  - Update a promotion code
  - list all promotion codes

  Stripe API reference: https://stripe.com/docs/api/promotion_codes
  """

  use Stripe.Entity
  import Stripe.Request

  @type t :: %__MODULE__{
          id: Stripe.id(),
          object: String.t(),
          active: boolean,
          code: String.t() | nil,
          coupon: Stripe.Coupon.t(),
          customer: String.t() | nil,
          created: Stripe.timestamp(),
          deleted: boolean | nil,
          expires_at: Stripe.timestamp() | nil,
          livemode: boolean,
          max_redemptions: pos_integer | nil,
          metadata: Stripe.Types.metadata(),
          restrictions: restrictions(),
          times_redeemed: non_neg_integer,
          valid: boolean
        }

  @type restrictions :: %{
          optional(:first_time_transaction) => boolean,
          optional(:minimum_amount) => pos_integer,
          optional(:minimum_amount_currency) => String.t()
        }

  defstruct [
    :id,
    :object,
    :active,
    :code,
    :coupon,
    :customer,
    :created,
    :deleted,
    :expires_at,
    :livemode,
    :max_redemptions,
    :metadata,
    :restrictions,
    :times_redeemed,
    :valid
  ]

  @plural_endpoint "promotion_codes"

  @doc """
  Create a promotion code.
  """
  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               :coupon => Stripe.id(),
               optional(:code) => String.t(),
               optional(:active) => boolean,
               optional(:customer) => Stripe.id(),
               optional(:expires_at) => Stripe.timestamp(),
               optional(:max_redemptions) => pos_integer,
               optional(:metadata) => Stripe.Types.metadata(),
               optional(:restrictions) => restrictions()
             }
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a promotion code.
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Updates the metadata of a promotion code. Other promotion code details (coupon, customer,
  expires_at, max_redemptions, restrictions) are, by design, not editable.

  Takes the `id` and a map of changes.
  """
  @spec update(Stripe.id() | t, params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params:
               %{
                 optional(:metadata) => Stripe.Types.metadata(),
                 optional(:active) => boolean
               }
               | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  List all promotion codes.
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:active) => boolean,
               optional(:created) => Stripe.date_query(),
               optional(:code) => String.t(),
               optional(:coupon) => Stripe.id(),
               optional(:customer) => Stripe.id(),
               optional(:ending_before) => t | Stripe.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | Stripe.id()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end
end
