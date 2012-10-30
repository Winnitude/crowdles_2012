class PlansController < ApplicationController
  def index
    #binding.remote_pry
    products = PlatformProduct.get_products_with_existing_plans
    @products = products[:products]
    @plans = products[:plans]
  end
end
