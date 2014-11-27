require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    
    #1. A user goes to the store index page
    get "/"
    assert_response :success
    assert_template "index"
    #2. They select a product, adding it to their cart
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success
    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    #3. They then check out, filling in their details on the checkout form
    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders", order: { name: "Alexandra Gurova",
                                          address: "Main Str.",
                                          email: "alexandra@example.com",
                                          pay_type: "Check" }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    #5. When they submit, an order is created in the database 
    #containing their information 
    #along with a single line item 
    #coresponding to the product they added to their cart.
    orders = Order.all
    assert_equal 1, orders.size
    
    order = orders[0]
    assert_equal "Alexandra Gurova", order.name
    assert_equal "Main Str.", order.address
    assert_equal "alexandra@example.com", order.email
    assert_equal "Check", order.pay_type
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    #6. Once the order has been received, 
    #an email is sent confirming their purchase
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["alexandra@example.com"], mail.to
    assert_equal "Alexandra Gurova <depot@example.com>", mail[:from].value
    assert_equal "Book Store Order Confirmation", mail.subject
    
    
    
    
    
    #1. A user goes to the store index page

    #2. They select a product, adding it to their cart
    
    #3. They then check out, filling in their details on the checkout form
    
    #5. When they submit, an order is created in the database 
    #containing their information 
    #along with a single line item 
    #coresponding to the product they added to their cart.
    
    #6. Once the order has been received, 
    #an email is sent confirming their purchase
    
  end
end
