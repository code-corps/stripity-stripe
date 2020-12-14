defmodule Stripe.AccountLinkTest do
  use Stripe.StripeCase, async: true

  test "is creatable for onboarding" do
    params = %{
      account: "acct_123",
      refresh_url: "https://stripe.com",
      return_url: "https://stripe.com",
      type: "account_onboarding"
    }

    assert {:ok, %Stripe.AccountLink{}} = Stripe.AccountLink.create(params)
    assert_stripe_requested(:post, "/v1/account_links")
  end
  test "is creatable for update" do
    params = %{
      account: "acct_123",
      refresh_url: "https://stripe.com",
      return_url: "https://stripe.com",
      type: "account_update"
    }

    assert {:ok, %Stripe.AccountLink{}} = Stripe.AccountLink.create(params)
    assert_stripe_requested(:post, "/v1/account_links")
  end
end
