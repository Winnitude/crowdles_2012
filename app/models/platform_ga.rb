class PlatformGa #will act as base class for the GA related things
  include Mongoid::Document
  has_one :platform_billing_profile
  has_one :default_billing_profile
  has_one :platform_user_role

  def initialize_billing_profiles param
    self.build_default_billing_profile(:currency => param[:currency]).save
    self.build_platform_billing_profile(:currency => param[:currency]).save
  end
end
