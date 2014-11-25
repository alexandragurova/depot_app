class Product < ActiveRecord::Base
    validates       :title, presence: true, 
                            uniqueness: true
    validates :description, presence: true
    validates   :image_url, presence: true, 
                            # allow_blank: true,
                            format: { with: %r{\.jpg|png|gif\Z}i, 
                                      message: "must be a URL for JPG, PNG or GIF" }
    validates       :price, numericality: { greater_than_or_equal_to: 0.01 }
end
