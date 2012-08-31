class GeneralSetting < GlobalAdmin
  include Mongoid::Document
  field :platform_name,                      :type => String ,:null => false, :default => 'Winnitude'
  field :platform_email   ,  :type => String ,:null => false
  field :platform_default_language,          :type => String ,:null => false, :default => 'English'
  field :platform_default_domain,            :type => String ,:null => false, :default => 'crowdles.com'
  field :mailchimp_integration_enabled,       :type => Boolean, :default => false
  field :freshbooks_integration_enabled,      :type => Boolean, :default => false
  field :platform_legal_terms_global,         :type => String
  field :arena_minimum_cap,                   :type => Integer
  field :arena_maximum_cap,                   :type => Integer
  field :arena_factor,                        :type => Float
  field :ga_facebook,                         :type => String
  field :ga_twitter,                          :type => String
  field :user_terms,                          :type => String
  field :project_terms,                       :type => String
  field :worker_terms,                        :type => String
  field :admin_group_terms,                   :type => String
  field :business_group_terms,                :type => String
  field :no_profit_terms,                     :type => String
  validates :platform_name   , :presence => true
  validates :platform_default_language   , :presence => true
  validates :platform_default_domain   , :presence => true

  def self.initialize_global_admin_general_settings(param)
    settings = GeneralSetting.create(:platform_name =>param[:platform_name], :platform_email =>param[:platform_email] ,
                                          :platform_default_language=> param[:language])
    #settings.save
    return settings
  end
end
