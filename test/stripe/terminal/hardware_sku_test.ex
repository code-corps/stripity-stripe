defmodule Stripe.Terminal.HardwareSkuTest do
  use Stripe.StripeCase, async: true

  describe "Retrieve" do
    @tag :skip
    test "retrieve hardware sku" do
      assert {:ok, %Stripe.Terminal.HardwareSku{}} =
               Stripe.Terminal.HardwareSku.retrieve("thsku_FmpapKIE13icT3")

      assert_stripe_requested(:get, "/v1/terminal/hardware_skus/thsku_FmpapKIE13icT3")
    end
  end

  describe "List" do
    @tag :skip
    test "list hardware skus" do
      assert {:ok, %Stripe.List{data: hardware_skus}} = Stripe.Terminal.HardwareSku.list()

      assert_stripe_requested(:get, "/v1/terminal/hardware_skus")
      assert is_list(hardware_skus)
      assert %Stripe.Terminal.HardwareSku{} = hd(hardware_skus)
    end
  end
end
