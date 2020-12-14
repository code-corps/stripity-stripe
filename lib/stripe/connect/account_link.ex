defmodule Stripe.AccountLink do
  @moduledoc """
  Work with Stripe Connect account link objects.

  You can:

  - Create an account link

  Stripe API reference: https://stripe.com/docs/api/account_links
  """

  use Stripe.Entity
  import Stripe.Request

  @type t :: %__MODULE__{
          object: String.t(),
          created: Stripe.timestamp(),
          expires_at: Stripe.timestamp(),
          url: String.t()
        }

  defstruct [
    :object,
    :created,
    :expires_at,
    :url
  ]

  @plural_endpoint "account_links"

  @doc """
  Create an account link.
  """
  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               :account => Stripe.Account.t() | Stripe.id(),
               :refresh_url => String.t(),
               :return_url => String.t(),
               :type => String.t(),
               optional(:collect) => String.t()
             }
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:account])
    |> make_request()
  end
end
