class CombineItemsInCart < ActiveRecord::Migration
  def up
    #Iterate over each cart
    Cart.all.each do |cart|
      #For each cart get a hash of pairs for each product with its quantity
      sums = cart.line_items.group(:product_id).sum(:quantity)
      #Iterate over each pair, extracting product and quantity
      sums.each do |product_id, quantity|
        if quantity > 1
          #Delete all line items of product if its quantity>1
          cart.line_items.where(product_id: product_id).delete_all
          #Add new item of product with quantity field = quantity
          item = cart.add_product(product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end
  
  def down
    #Find grouped by product line items
    LineItem.where("quantity>1").each do |item|
      #For each grouping product create n line items, where n is quantity of product
      item.quantity.times do
        LineItem.create(product_id: item.product_id, cart_id: item.cart_id)
      end
      #Delete original grouped by product item
      item.destroy
    end
  end
end
