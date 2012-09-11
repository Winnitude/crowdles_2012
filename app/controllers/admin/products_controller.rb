
  class Admin::ProductsController < ApplicationController
    # GET /products
    # GET /products.json
    def index
      @products = PlatformProduct.all
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
      @product = Product.find(params[:id])
    end

    # POST /products
    # POST /products.json
    def create
      @product = PlatformProduct.new(params[:product])

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
      @product = Product.find(params[:id])

      respond_to do |format|
        if @product.update_attributes(params[:product])
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


