class RegistrationsController <  Devise::RegistrationsController
  before_filter :redirect_if_already_exist ,:only=>[:create]
  before_filter :redirect_to_initial_page_if_platform_is_not_configured_yet ,:only => [:new]




  private

  def redirect_if_already_exist
    #render :text=>"dsdgdsg"
    check_user = User.where(:email=>params[:user][:email]).to_a.first
    if !check_user.nil?
      if !check_user.confirmation_token.nil?
        redirect_to :controller => 'homes', :action => 'show_error_msg', :id =>check_user.id
      end
    end
  end
end
