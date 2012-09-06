class AgProjectsSetting
  include Mongoid::Document
  belongs_to :platform_admin_group
  field :self_management ,:type => Boolean
  field :arena_flag ,:type => Boolean
end
