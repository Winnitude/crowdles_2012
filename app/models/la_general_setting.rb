class LaGeneralSetting
  include Mongoid::Document
  before_save :set_settings
  belongs_to :platform_local_admin
  field :la_country,                                           :type => String
  validates :la_country,
            :uniqueness => true
  field :la_language,                                             :type => String
  field :la_platform_home,                                        :type => String
  field :master_administration_deviation,                      :type => Boolean
  field :master_worker_deviation,                              :type => String
  field :master_worker_deviation_comment,                      :type => String
  field :la_facebook,                                          :type=> String
  field :la_twitter,                                           :type=> String
  field :la_linked_in,                                         :type=> String
  field :local_admin_name,                                      :type=> String

  def set_settings
      self.la_platform_home = "crowdles.com/country/"+ self.la_country.downcase
      self.local_admin_name = "Crowdles "+ self.la_country
  end
end
