class Admin::LocalAdminsController < ApplicationController
  before_filter :should_be_global_admin
 def index
   @local_admins = PlatformLocalAdmin.all.includes(:la_general_setting)
   #@local_admins = PlatformLocalAdmin.all
   @local_admins.each do|i|
      i.la_general_setting.inspect
   end
 end
end
