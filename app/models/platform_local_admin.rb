class PlatformLocalAdmin
  include Mongoid::Document
  has_one :paas_billing_profile
  belongs_to :platform_global_admin
  belongs_to :user
  has_many :platform_roles_managements
  has_one :la_contact
  has_one :la_general_setting
  has_one :la_paas_setting
  has_one :la_profile
  has_one :la_term


  field :is_master,                        :type => Boolean
  field :creation_date,                    :type => DateTime
  field :deactivation_date,                :type => DateTime
  field :status,                           :type => String

  def self.create_main_local_admin user ,param
    local_admin= user.platform_local_admins.create(:is_master => true , :creation_date => DateTime.now ,:status =>"active" )
    PlatformRolesManagement.assign_local_admin_role user, local_admin
    local_admin.build_paas_billing_profile(:currency => param[:currency] ).save
  end
end
