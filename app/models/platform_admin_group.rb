class PlatformAdminGroup
  include Mongoid::Document
  before_save :set_dates
  has_one :platform_products_management
  has_one :ag_general_setting
  has_one :ag_profile
  has_one :ag_projects_setting
  has_one :ag_commissions_setting
  has_one :ag_paas_setting
  belongs_to :user
  belongs_to :platform_local_admin
  has_many :platform_roles_managements
  has_one :paas_billing_profile
  has_one :default_billing_profile
  field :admin_group_type ,:type => String
  field :ag_creation_date ,                         :type => Date
  field :ag_expiration_date ,                       :type => Date
  field :ag_deactivation_date ,                     :type => Date
  field :status ,                                   :type => String

  def self.create_main_admin_group_for_platform_master_country user, param ,local_admin
       product = PlatformProduct.get_default_product.first
       admin_group = user.platform_admin_groups.new(:admin_group_type =>"main" ,:status => "active")
       admin_group.platform_local_admin = local_admin
       admin_group.save!
       PlatformProductsManagement.grant_product product, admin_group
       PlatformRolesManagement.assign_admin_group_owner_role user,admin_group
       admin_group.build_all_mag_settings local_admin,param
  end

  def build_all_mag_settings local_admin, param
    self.build_ag_general_setting(:country => local_admin.la_general_setting.la_country, :language => param[:language], :self_management => false, :arena_flag => false).save
    self.build_ag_projects_setting(:self_management => false, :arena_flag => false).save
    self.build_ag_commissions_setting(:bg_free_private_commissions_allowed => true ,:bg_free_pro_commissions_allowed => true,:bg_free_standard_commissions_allowed => true).save
    self.build_ag_paas_setting(:paas_fees_exemption => "permanent").save
    self.build_paas_billing_profile(:currency => param[:currency] ).save
    self.build_default_billing_profile(:currency => param[:currency] ).save
  end

  def set_dates
     self.ag_creation_date = DateTime.now
  end
end
