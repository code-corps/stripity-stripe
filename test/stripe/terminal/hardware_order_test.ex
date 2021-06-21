defmodule Stripe.Terminal.HardwareOrderTest do
  use Stripe.StripeCase, async: true

  describe "Create" do
    @tag :skip
    test "create hardware order" do
      params = %{
        hardware_order_items: [
          %{
            quantity: 2,
            terminal_hardware_sku: "thsku_FmpapKIE13icT3"
          }
        ],
        payment_type: "monthly_invoice",
        shipping: %{
          name: "Jenny Rosen",
          address: %{
            line1: "1234 Main Street",
            city: "San Francisco",
            state: "CA",
            country: "US",
            postal_code: "94111"
          },
          company: "Rocket Rides",
          phone: "15555555555",
          email: "test@example.com"
        },
        shipping_method: "standard"
      }

      assert {:ok, %Stripe.Terminal.HardwareOrder{status: "draft"}} =
               Stripe.Terminal.HardwareOrder.create(params)

      assert_stripe_requested(:post, "/v1/terminal/hardware_orders")
    end
  end

  describe "Retrieve" do
    @tag :skip
    test "retrieve hardware order" do
      assert {:ok, %Stripe.Terminal.HardwareOrder{}} =
               Stripe.Terminal.HardwareOrder.retrieve("thor_1IQIcTELrVx5KpCHhKYmqBm8")

      assert_stripe_requested(:get, "/v1/terminal/hardware_orders/thor_1IQIcTELrVx5KpCHhKYmqBm8")
    end
  end

  describe "List" do
    @tag :skip
    test "list hardware orders" do
      assert {:ok, %Stripe.List{data: hardware_orders}} = Stripe.Terminal.HardwareOrder.list()

      assert_stripe_requested(:get, "/v1/terminal/hardware_orders")
      assert is_list(hardware_orders)
      assert %Stripe.Terminal.HardwareOrder{} = hd(hardware_orders)
    end
  end

  describe "Confirm" do
    @tag :skip
    test "confirm hardware order" do
      assert {:ok, %Stripe.Terminal.HardwareOrder{status: "pending"}} =
               Stripe.Terminal.HardwareOrder.confirm("thor_1IQIcTELrVx5KpCHhKYmqBm8")

      assert_stripe_requested(
        :post,
        "/v1/terminal/hardware_orders/thor_1IQIcTELrVx5KpCHhKYmqBm8/confirm"
      )
    end
  end

  describe "Cancel" do
    @tag :skip
    test "Cancel hardware order" do
      assert {:ok, %Stripe.Terminal.HardwareOrder{status: "canceled"}} =
               Stripe.Terminal.HardwareOrder.confirm("thor_1IQIcTELrVx5KpCHhKYmqBm8")

      assert_stripe_requested(
        :post,
        "/v1/terminal/hardware_orders/thor_1IQIcTELrVx5KpCHhKYmqBm8/cancel"
      )
    end
  end
end
