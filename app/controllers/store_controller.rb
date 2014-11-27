class StoreController < ApplicationController
  skip_before_action :authorize
  
  include CurrentCart
  before_action :set_cart
  
  def index
    @products = Product.order(:title)
    
    if session[:counter].nil?
      @view_store_counter = 0
    else
      @view_store_counter = session[:counter]
      @view_store_counter += 1
    end
    
    session[:counter] = @view_store_counter
  end
end
