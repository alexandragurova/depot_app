require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end
  
  test "title should be unique" do
    product = Product.new(title: products(:ruby).title,
                              description: "BlahBlahBlah",
                              image_url: "image.png",
                              price: 12.00)
    assert product.invalid?
    assert_equal [I18n.translate("errors.messages.taken")], product.errors[:title]
  end
  
  test "image url should be valid" do
    product = Product.new(title: "GoF Patterns",
                    description: "Cool Book",
                    price: 15.00)
    ok_url = %w{ book.png book.gif book.JPG Book.Gif http://a.b.c./x/y/z/book.png }
    bad_url = %w{ book.doc book.gi book.gif/more book.gif.more }
    
    ok_url.each do |image|
      product.image_url = image
      assert product.valid?, "#{image} should be valid"
    end
    
    bad_url.each do |image|
      product.image_url = image
      assert product.invalid?, "#{image} should not be valid"
    end
  end
  
  test "price should be positive" do
    product = Product.new(title: "GoF Patterns",
                    description: "Cool Book",
                    image_url: "image.gif")
                    
    product.price = -1
    assert product.invalid? 
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price] 
    
    product.price = 0
    assert product.invalid? 
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end
end
