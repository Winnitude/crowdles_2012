class Admin::LanguagesController < ApplicationController
  def index
    #@languages = ServiceLanguage.all.paginate(:page => params[:page], :per_page => 10)
    if(params[:re_query])
      @languages = ServiceLanguage.all
      if params[:name] != ""
        @languages = @languages.select{|i| i.english_name.downcase == params[:name].downcase rescue nil}
      end

      if params[:iso_code] != ""
        @languages = @languages.select{|i| i.iso_code.downcase == params[:iso_code].downcase rescue nil}
      end

      if params[:local_name] != ""
        @languages = @languages.select{|i| i.local_name.downcase == params[:local_name].downcase rescue nil}
      end

      if params[:is_active] != "All"
        is_active = params[:is_active].downcase == "true" ? 1 : 0
        @languages = @languages.select{|i| i.is_active == is_active  rescue nil}
      end

      if params[:is_default] != "All"
        is_default = params[:is_default].downcase == "true" ? 1 : 0
        @languages = @languages.select{|i| i.is_default == is_default  rescue nil}
      end

    else
      @languages = ServiceLanguage.all
    end
    @languages = @languages.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @language = ServiceLanguage.find(params[:id])
  end

  def update
    @language = ServiceLanguage.find(params[:id])
    if @language.update_attributes(params[:service_language])
      redirect_to languages_path ,:notice => "Language Updated Successfully"
    end
  end
end
