class ProductsController < ApplicationController
	def index
		@products = Shoppe::Product.root.ordered.includes(:product_category, :variants)
    	@products = @products.group_by(&:product_category)
	end

	def show
		@product = Shoppe::Product.find_by_permalink(params[:permalink])
	end

	def buy
  		@product = Shoppe::Product.find_by_permalink!(params[:permalink])
  		current_order.order_items.add_item(@product, 1)
  		redirect_to :back
	end

	def remove
		@item = Shoppe::Product.find_by_name(params[:item_name])
		@item.remove
	end
end
