defmodule Stripe.EphemeralKey do
  @moduledoc """
  Work with Stripe EphemeralKey objects.

  You can:

  - Create a ephemeral key

  Does not yet render lists or take options.

  Does not have an official API docs endpoint,
  but is required for iOS and Android SDK functionality.

  Explained in
  https://stripe.com/docs/mobile/ios/basic#ephemeral-key
  https://stripe.com/docs/mobile/android/basic#set-up-ephemeral-key

  Stripe API reference: https://stripe.com/docs/api#customer
  """

  use Stripe.Entity
  import Stripe.Request

  defstruct [
    :id,
    :object,
    :created,
    :expires,
    :secret,
    :associated_objects,
    :livemode
  ]

  @type t :: %__MODULE__{}

  @plural_endpoint "ephemeral_keys"

  @doc """
  Create an ephemeral key.
  """
  @spec create(params, String.t(), Keyword.t()) :: {:ok, t} | {:error, %Stripe.Error{}}
        when params: %{:customer => Stripe.id()} | %{issuing_card: Stripe.id()}
  def create(params, api_version, opts \\ []) do
    new_request([api_version: api_version] ++ opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end
end
