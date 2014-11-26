class Product < ActiveRecord::Base
    has_many :line_items
    
    before_destroy :ensure_not_referenced_by_any_line_items
    
    validates       :title, presence: true, 
                            uniqueness: true
    validates :description, presence: true
    validates   :image_url, presence: true, 
                            # allow_blank: true,
                            format: { with: %r{\.jpg|png|gif\Z}i, 
                                      message: "must be a URL for JPG, PNG or GIF" }
    validates       :price, numericality: { greater_than_or_equal_to: 0.01 }
    
    def self.latest
        Product.order(:updated_at).last
    end
    
    private
    
        #Ensure there are no line items referencing this product
        def ensure_not_referenced_by_any_line_items
            if line_items.empty?
                return true
            else
                errors.add(:base, "Line Items present")
                #if hook method return false
                #action would never be executed
                #(row won't be destroyed)
                return false
            end
        end
end
