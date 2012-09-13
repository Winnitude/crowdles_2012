
class Admin::ProductsController < ApplicationController
  before_filter :should_be_global_admin
  # GET /products
  # GET /products.json
  def index
    if(params[:re_query])
      @products = PlatformProduct.all
      if params[:name] != ""
        @products = @products.select{|i| i.platform_product_name.downcase == params[:name].downcase rescue nil}
      end

      if params[:target] != "All"
        @products = @products.select{|i| i.product_target.downcase == params[:target].downcase rescue nil}
      end
      if params[:status] != "All"
        @products = @products.select{|i| i.status.downcase == params[:status].downcase rescue nil}
      end
    else
      @products = PlatformProduct.all
    end
  end


  def new
    @product = PlatformProduct.new
  end

  # GET /products/1/edit
  def edit
    @product = PlatformProduct.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = PlatformProduct.new(params[:platform_product])
    @product.is_default_sag= params[:default] if @product.product_target.downcase == "sag"
    @product.is_default= params[:default]  if @product.product_target.downcase == "mag"

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = PlatformProduct.find(params[:id])
    @product.is_default_sag= params[:default] if @product.product_target.downcase == "sag"
    @product.is_default= params[:default]  if @product.product_target.downcase == "mag"
    respond_to do |format|
      if @product.update_attributes(params[:platform_product])
        format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json

end


