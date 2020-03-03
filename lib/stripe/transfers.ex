defmodule Stripe.Transfers do
  @moduledoc """
  Functions for working with Transfers within Stripe.

  * update a transfer
  * get a transfer

  Stripe API Reference: https://stripe.com/docs/api#transfers
  """

  @endpoint "transfers"

  def get(id) do
    get(id, Stripe.config_or_env_key())
  end

  def get(id, key) do
    Stripe.make_request_with_key(:get, "#{@endpoint}/#{id}", key)
    |> Stripe.Util.handle_stripe_response()
  end

  def change(id, params) do
    change(id, params, Stripe.config_or_env_key())
  end

  def change(id, params, key) do
    Stripe.make_request_with_key(:post, "#{@endpoint}/#{id}", key, params)
    |> Stripe.Util.handle_stripe_response()
  end
end
