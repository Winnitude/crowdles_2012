class PlatformGlobalAdmin #will act as base class for the GA related things
  include Mongoid::Document
  has_one :paas_billing_profile
  has_one :default_billing_profile
  has_one :platform_user_role
  has_one :ga_general_setting
  has_one :ga_integration
  has_one :ga_projects_commission
  has_one :ga_projects_setting
  has_one :ga_term
  has_many :platform_local_admins


  def initialize_billing_profiles param
    self.build_default_billing_profile(:currency => param[:currency]).save
    self.build_paas_billing_profile(:currency => param[:currency]).save
  end

  def create_all_settings param ,user
    self.initialize_billing_profiles param
    general_settings = self.build_ga_general_setting
    general_settings.initialize_global_admin_general_settings(param)
    integration_setting = self.build_ga_integration.save
    commissions_setting = self.build_ga_projects_commission.save
    terms = self.build_ga_term.save
    projects_setting = self.build_ga_projects_setting.save
    PlatformRolesManagement.assign_global_admin_role user , self
  end




end
