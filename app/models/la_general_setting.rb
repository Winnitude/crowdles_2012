class LaGeneralSetting
  include Mongoid::Document
  belongs_to :platform_local_admin
  field :la_country,                                           :type => String
  validates :la_country,
            :uniqueness => true
  field :language,                                             :type => String
  field :platform_home,                                        :type => String
  field :master_administration_deviation,                      :type => String
  field :master_worker_deviation,                              :type => String
  field :master_worker_deviation_comment,                      :type => String
  field :la_facebook,                                          :type=> String
  field :la_twitter,                                           :type=> String
  field :la_linked_in,                                         :type=> String
end
