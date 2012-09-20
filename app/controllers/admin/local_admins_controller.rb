class Admin::LocalAdminsController < ApplicationController
  before_filter :should_be_global_admin
 def index
   @local_admins = PlatformLocalAdmin.all.paginate(:page => params[:page], :per_page => 10)
 end
end
