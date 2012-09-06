class AgGeneralSetting
  include Mongoid::Document
  field :admin_group_type ,:type => String
  field :admin_group_name ,:type => String
  field :country ,:type => String
  field :language ,:type => String
end
