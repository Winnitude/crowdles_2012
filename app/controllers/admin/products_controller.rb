
class Admin::ProductsController < ApplicationController
  before_filter :should_be_global_admin
  # GET /products
  # GET /products.json
  def index
    if(params[:requery])
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

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @products }
      end
    else
      @products = PlatformProduct.all
    end
  end


  def new
    @product = PlatformProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = PlatformProduct.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = PlatformProduct.new(params[:platform_product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = PlatformProduct.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:platform_product])
        format.html { redirect_to products_path, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json

end


