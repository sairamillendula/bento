require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  test "requires item in cart" do
    get :new
    assert_redirected_to products_path
    assert_equal flash[:notice], "#{I18n.t 'carts.is_empty'}."
  end

  test "should get new" do
    cart = Cart.create
    session[:cart_id] = cart.id
    LineItem.create(cart_id: cart.id, product_id: products(:one).id)

    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, :order => @order.attributes
    end
    assert_redirected_to order_path(@order)
  end
  
end