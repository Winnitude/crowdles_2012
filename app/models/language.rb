class Language
  include Mongoid::Document
  field :is_active, :type => Integer
  field :local_name, :type => String
  field :english_name, :type => String
  field :iso_code, :type => String
end
