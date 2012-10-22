class AdaptivePaymentsController < ApplicationController
  require 'cgi'
  require 'profile'
  require 'caller'
  @@profile = PayPalSDKProfiles::Profile
  @@ep=@@profile.endpoints
  @@clientDetails=@@profile.client_details
  def getStatus
  end

  def verified_status
    @@ep["SERVICE"]="/AdaptiveAccounts/GetVerifiedStatus"
    @caller =  PayPalSDKCallers::Caller.new(false)
    req={
        "requestEnvelope.errorLanguage" => "en_US",
        "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
        "clientDetails.deviceId" =>@@clientDetails["deviceId"],
        "clientDetails.applicationId" => @@clientDetails["applicationId"],
        "emailAddress"=>params[:email],
        "matchCriteria" =>params[:matchCriteria],
        "firstName" =>params[:firstName],
        "lastName"=>params[:lastName]
    }
    #Make the call to PayPal to get verified status on behalf of the caller If an error occured, show the resulting errors
    @transaction = @caller.call(req)

    if (@transaction.success?)
      session[:verifiedStatus_response]=@transaction.response
      #redirect_to :controller => 'getverifiedstatus',:action => 'details'
      render :json => @transaction.response
    else
      session[:paypal_error]=@transaction.response
      redirect_to :controller => 'calls', :action => 'error'
    end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end

  def details
    @response = session[:verifiedStatus_response]
  end

  def error
    @response = session[:paypal_error]
  end

end
