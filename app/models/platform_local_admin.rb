class PlatformLocalAdmin
  include Mongoid::Document
  has_one :paas_billing_profile
  belongs_to :platform_global_admin
  belongs_to :user
  has_one :platform_roles_management
  has_one :la_contact
  has_one :la_general_setting
  has_one :la_paas_setting
  has_one :la_profile
  has_one :la_term
  has_many :platform_admin_groups
  field :is_master,                        :type => Boolean
  field :creation_date,                    :type => DateTime
  field :deactivation_date,                :type => DateTime
  field :status,                           :type => String

  def self.create_main_local_admin user ,param
    local_admin= user.platform_local_admins.create(:is_master => true , :creation_date => DateTime.now ,:status =>"active" )
    PlatformRolesManagement.assign_local_admin_role user, local_admin
    general_setting = local_admin.build_la_general_setting(:la_language => param[:language] ,:la_country => param[:platform_master_country]).save
    profile = local_admin.build_la_profile(:la_email => param[:platform_email]).save
    pass_setting = local_admin.build_la_paas_setting.save
    la_term = local_admin.build_la_term.save
    la_contact = local_admin.build_la_contact.save
    local_admin.build_paas_billing_profile(:currency => param[:currency] ).save
    return local_admin
  end

  def self.create_all_local_admins_with_their_mag param
     all_countries = ServiceCountry.where(:is_active => 1, :is_default => 0)
     all_countries.each do |i|
       local_admin=self.create(:is_master => false , :creation_date => DateTime.now ,:status =>"suspended")
       general_setting = local_admin.build_la_general_setting(:la_language => param[:language] ,:la_country => i.country_english_name).save
       profile = local_admin.build_la_profile().save
       pass_setting = local_admin.build_la_paas_setting.save
       la_term = local_admin.build_la_term.save
       la_contact = local_admin.build_la_contact.save
       local_admin.build_paas_billing_profile(:currency => param[:currency] ).save
       local_admin.create_mag param
     end
  end

  def create_mag param
    admin_group = self.platform_admin_groups.create(:admin_group_type =>"main" ,:status => "suspended")
    admin_group.build_all_mag_settings self, param
  end
end
