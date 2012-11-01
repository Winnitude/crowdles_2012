# app/controllers/confirmations_controller.rb
class ConfirmationsController < Devise::PasswordsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!
  def new
#    super
  end

  # PUT /resource/confirmation
  def update
    params[:user][:user_terms_accepted] = params[:user][:user_terms_accepted] == "1" ? true : false
    with_unconfirmed_confirmable do

      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid?
          do_confirm
          #@confirmable.update_attribute(:status , "active")    #to make him active
          @confirmable.status = "active"
          @confirmable.country = params[:user][:country]
          @confirmable.language = params[:user][:language]
          @confirmable.user_terms_accepted =  params[:user][:user_terms_accepted]
          @confirmable.save
          #binding.remote_pry
          @profile = (@confirmable.build_user_profile  params[:user_profile]).save
          @billing_profile = @confirmable.build_default_billing_profile.save
        else
          @countries = ServiceCountry.all.select{|i| i.is_active ==1}.collect{|i| i.country_english_name}
          @language = ServiceLanguage.all.select{|i| i.is_active ==1}.collect{|i| i.english_name}
          do_show
          @confirmable.errors.clear #so that we wont render :new
        end
      else
        self.class.add_error_on(self, :email, :password_allready_set)
      end
    end

    if !@confirmable.errors.empty?
      @countries = ServiceCountry.all.select{|i| i.is_active ==1}.collect{|i| i.country_english_name}
      @language = ServiceLanguage.all.select{|i| i.is_active ==1}.collect{|i| i.english_name}
      render 'devise/confirmations/new' #Change this if you doens't have the views on default path
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show

    @countries = ServiceCountry.all.select{|i| i.is_active ==1}.collect{|i| i.country_english_name}
    @language = ServiceLanguage.all.select{|i| i.is_active ==1}.collect{|i| i.english_name}
    with_unconfirmed_confirmable do
      #binding.remote_pry
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    if !@confirmable.errors.empty?
      #binding.remote_pry
      if (@confirmable.status == "active")
        redirect_to root_path ,:notice => "Sorry this page has been expired"
      else
        set_flash_message(:error, :invalid)
        render 'devise/confirmations/new' #Change this if you doens't have the views on default path
      end
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show' #Change this if you doens't have the views on default path
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

#  def only_if_unconfirmed
#    pending_any_confirmation {yield}
#  end

end