class PlatformGlobalAdmin #will act as base class for the GA related things
  include Mongoid::Document
  has_one :paas_billing_profile
  has_one :default_billing_profile
  has_one :platform_user_role
  has_one :ga_general_setting
  has_one :ga_integration


  def initialize_billing_profiles param
    self.build_default_billing_profile(:currency => param[:currency]).save
    self.build_paas_billing_profile(:currency => param[:currency]).save
  end


end
