class Admin::CurrenciesController < ApplicationController
  def index
    #@currencies = ServiceCurrency.all.paginate(:page => params[:page], :per_page => 10)
    if(params[:re_query])
      @currencies = ServiceCurrency.all
      if params[:name] != ""
        @currencies = @currencies.select{|i| i.description.downcase == params[:name].downcase rescue nil}
      end

      if params[:iso_code] != ""
        @currencies = @currencies.select{|i| i.iso_code.downcase == params[:iso_code].downcase rescue nil}
      end


      if params[:is_active] != "All"
        is_active = params[:is_active].downcase == "true" ? 1 : 0
        @currencies = @currencies.select{|i| i.is_active == is_active  rescue nil}
      end

    else
      @currencies = ServiceCurrency.all
    end
    @currencies = @currencies.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @currency = ServiceCurrency.find(params[:id])
  end

  def update
    @currency = ServiceCurrency.find(params[:id])
    if @currency.update_attributes(params[:service_currency])
      redirect_to edit_currency_path(@currency) ,:notice => "Currency Updated Successfully"
    end
  end
end
