defmodule Stripe.Terminal.HardwareSku do
  @moduledoc """
  A TerminalHardwareSKU represents a SKU for Terminal hardware. A SKU is a
  representation of an product available for purchase, containing information
  such as the name, price, and images.

  You can:
  - [Retrieve a Hardware Sku](https://stripe.com/docs/api/terminal/hardware_skus/retrieve)
  - [List all Hardware Skus](https://stripe.com/docs/api/terminal/hardware_skus/list)
  """

  use Stripe.Entity
  import Stripe.Request
  require Stripe.Util

  @type t :: %__MODULE__{
          id: Stripe.id(),
          object: String.t() | nil,
          amount: integer,
          country: String.t(),
          currency: String.t(),
          max_per_order: integer | nil,
          product_type: String.t()
        }

  defstruct [
    :id,
    :object,
    :amount,
    :country,
    :currency,
    :max_per_order,
    :product_type
  ]

  @plural_endpoint "terminal/hardware_skus"

  @doc """
  Retrieve an available terminal hardware sku
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List all available terminal hardware skus
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:country) => String.t(),
               optional(:product_type) => String.t()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> make_request()
  end
end
