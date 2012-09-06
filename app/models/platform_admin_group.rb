class PlatformAdminGroup
  include Mongoid::Document
  has_one :platform_products_management
  has_one :ag_general_setting
  has_one :ag_profile
  has_one :ga_projects_setting
  has_one :ag_commissions_setting
  has_one :ag_paas_setting
  belongs_to :user
  belongs_to :platform_local_admin
  has_many :platform_roles_managements
  field :admin_group_type ,:type => String
  field :ag_creation_date ,                         :type => Date
  field :ag_expiration_date ,                       :type => Date
  field :ag_deactivation_date ,                     :type => Date
  field :status ,                                   :type => String

  def create_main_admin_group_for_platform_master_country user, param

  end
end
