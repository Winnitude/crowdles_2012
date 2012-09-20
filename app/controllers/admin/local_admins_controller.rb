class Admin::LocalAdminsController < ApplicationController
  before_filter :should_be_global_admin
 def index
   @local_admins = PlatformLocalAdmin.all.includes([:la_general_setting,:user])
   @local_admins = @local_admins.paginate(:page => params[:page], :per_page => 10)
 end
end
