class PlatformGa #will act as base class for the GA related things
  include Mongoid::Document
  has_one :billing_profile_paas
  has_one :billing_profile_default
  has_one :platform_user_role

  def initialize_billing_profiles param
    self.build_billing_profile_default(:currency => param[:currency]).save
    self.build_paas_billing_profile(:currency => param[:currency]).save
  end
end
