class GaProjectsSetting
  include Mongoid::Document
  belongs_to :platform_global_admin
  field :arena_minimum_cap,                   :type => Integer
  field :arena_maximum_cap,                   :type => Integer
  field :arena_factor,                        :type => Float
end
