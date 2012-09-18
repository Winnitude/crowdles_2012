class Admin::LocalAdminsController < ApplicationController
  before_filter :should_be_global_admin
 def index
   @local_admins = PlatformLocalAdmin.all.includes(:la_general_setting)
 end
end
