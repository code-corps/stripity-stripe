defmodule Stripe.Terminal.HardwareOrder do
  @moduledoc """
  A TerminalHardwareOrder represents an order for Terminal hardware, containing
  information such as the price, shipping information and the items ordered

  You can:
  - [Create a Hardware Order](https://stripe.com/docs/api/terminal/hardware_orders/create)
  - [Retrieve a Hardware Order](https://stripe.com/docs/api/terminal/readers/retrieve)
  - [List all Hardware Orders](https://stripe.com/docs/api/terminal/hardware_orders/list)
  - [Confirm a draft Hardware Order](https://stripe.com/docs/api/terminal/hardware_orders/confirm)
  - [Cancel a Hardware Order](https://stripe.com/docs/api/terminal/hardware_orders/cancel)
  """

  use Stripe.Entity
  import Stripe.Request
  require Stripe.Util

  @type t :: %__MODULE__{
          id: Stripe.id(),
          amount: integer,
          currency: String.t(),
          hardware_order_items: hardware_order_items(),
          metadata: Stripe.Types.metadata() | nil,
          payment_type: String.t(),
          shipping: Stripe.Types.shipping(),
          shipping_method: String.t(),
          status: String.t(),
          object: String.t() | nil,
          created: Stripe.timestamp() | nil,
          invoice: invoice() | nil,
          livemode: boolean,
          shipment_tracking: shipment_tracking(),
          tax: integer,
          total_tax_amounts: total_tax_amounts(),
          updated: Stripe.timestamp() | nil
        }

  @type hardware_order_items ::
          list(%{
            amount: integer | nil,
            currency: String.t(),
            quantity: integer,
            terminal_hardware_sku: Stripe.Terminal.HardwareSku.t() | String.t()
          })

  @type invoice :: %{
          status: String.t() | nil,
          url: String.t() | nil
        }

  @type rate :: %{
          display_name: String.t() | nil,
          jurisdiction: String.t() | nil,
          percentage: float | nil
        }

  @type shipment_tracking ::
          list(%{
            carrier: String.t() | nil,
            tracking_number: String.t() | nil
          })

  @type total_tax_amounts ::
          list(%{
            amount: String.t() | nil,
            inclusive: boolean | nil,
            rate: rate() | nil
          })

  defstruct [
    :id,
    :amount,
    :currency,
    :hardware_order_items,
    :metadata,
    :payment_type,
    :shipping,
    :shipping_method,
    :status,
    :object,
    :created,
    :invoice,
    :livemode,
    :shipment_tracking,
    :tax,
    :total_tax_amounts,
    :updated
  ]

  @plural_endpoint "terminal/hardware_orders"

  @doc """
  Create a new terminal hardware order
  """

  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               :hardware_order_items => hardware_order_items(),
               :payment_type => String.t(),
               :shipping => Stripe.Types.shipping(),
               :shipping_method => String.t(),
               optional(:confirm) => boolean,
               optional(:metadata) => Stripe.Types.metadata()
             }

  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Retrieve a terminal hardware order
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  List all terminal hardware orders
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:status) => String.t(),
               optional(:ending_before) => t | Stripe.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | Stripe.id()
             }
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end

  @doc """
  Confirm a draft terminal hardware order. This places the order so it is no
  longer a draft.
  """
  @spec confirm(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def confirm(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/confirm")
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Cancel a terminal hardware order
  """
  @spec cancel(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def cancel(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/cancel")
    |> put_method(:post)
    |> make_request()
  end
end
