defmodule Stripe.URI do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      defp build_url(ext \\ "") do
        if ext != "", do: ext = "/" <> ext

        @base <> ext
      end
    end
  end

  @doc """
  Takes a map and turns it into proper query values.
  ## Example
  card_data = %{
    cards: [
      %{
        number: 424242424242,
        exp_year: 2014
      },
      %{
        number: 424242424242,
        exp_year: 2017
      }
    ]
  }
  Stripe.URI.encode_query(card_data) # cards[0][number]=424242424242&cards[0][exp_year]=2014&cards[1][number]=424242424242&cards[1][exp_year]=2017
  """
  def encode_query(map) do
    map |> UriQuery.params() |> URI.encode_query()
  end
end
