class GaGeneralSetting
  include Mongoid::Document
  belongs_to :platform_global_admin
  field :platform_name,                      :type => String
  field :platform_email   ,                  :type => String
  field :platform_default_language,          :type => String
  field :platform_default_domain,            :type => String
  field :platform_legal_terms_global,         :type => String
  field :ga_facebook,                         :type => String
  field :ga_twitter,                          :type => String
  validates :platform_name   , :presence => true
  validates :platform_default_language   , :presence => true


  def initialize_global_admin_general_settings(param)

    self.platform_name = param[:platform_name]
    self.platform_email = param[:platform_email]
    self.platform_default_language = param[:language]
    self.save
  end
end
