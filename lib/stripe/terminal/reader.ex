defmodule Stripe.Terminal.Reader do
  @moduledoc """
  A Reader represents a physical device for accepting payment details

  You can:
  - [Create a Reader](https://stripe.com/docs/api/terminal/readers/create)
  - [Retrieve a Reader](https://stripe.com/docs/api/terminal/readers/retrieve)
  - [Update a Reader](https://stripe.com/docs/api/terminal/readers/update)
  - [Delete a Reader](https://stripe.com/docs/api/terminal/readers/delete)
  - [List all Readers](https://stripe.com/docs/api/terminal/readers/list)
  - [Cancel a reader action](not public)
  - [Process a payment intent](not public)
  """

  use Stripe.Entity
  import Stripe.Request
  require Stripe.Util

  @type t :: %__MODULE__{
          id: Stripe.id(),
          device_type: String.t(),
          label: String.t(),
          location: String.t(),
          metadata: Stripe.Types.metadata(),
          serial_number: String.t(),
          status: String.t(),
          object: String.t(),
          device_sw_version: String.t(),
          ip_address: String.t(),
          livemode: boolean(),
          action: action() | nil
        }

  @type action :: %{
          type: String.t() | nil,
          process_payment_intent: map() | nil,
          status: String.t() | nil,
          failure_code: String.t() | nil,
          failure_message: String.t() | nil,
          livemode: boolean()
        }

  defstruct [
    :id,
    :device_type,
    :label,
    :location,
    :metadata,
    :serial_number,
    :status,
    :object,
    :device_sw_version,
    :ip_address,
    :livemode,
    :action
  ]

  @plural_endpoint "terminal/readers"

  @doc """
  Create a new reader
  """

  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params:
               %{
                 :registration_code => String.t(),
                 optional(:label) => String.t(),
                 optional(:location) => Stripe.id(),
                 optional(:metadata) => Stripe.Types.metadata()
               }
               | %{}

  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Retrieve a reader with a specified `id`.
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a reader.

  Takes the `id` and a map of changes.
  """
  @spec update(Stripe.id() | t, params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:label) => String.t(),
               optional(:metadata) => Stripe.Types.metadata()
             }
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Delete an reader.
  """
  @spec delete(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all readers.
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:device_type) => String.t(),
               optional(:location) => t | Stripe.id(),
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
  Cancel any action pending on the physical reader

  Takes the `id`.
  """
  @spec cancel_action(Stripe.id() | t, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}

  def cancel_action(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/cancel_action")
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Process a payment intent by an async request to the the provided reader

  Takes the `id` and a map with a payment intents id.
  """
  @spec process_payment_intent(Stripe.id() | t, params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               :payment_intent => String.t()
             }

  def process_payment_intent(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/process_payment_intent")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end
end
