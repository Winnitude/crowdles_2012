class ServiceLanguage
  include Mongoid::Document
  field :is_active, :type => Integer
  field :local_name, :type => String
  field :english_name, :type => String
  field :iso_code, :type => String
  field :is_default, :type => Integer

  def self.make_language_active_and_default(language)
    lang = where(:english_name => language).first
    lang.update_attributes({:is_active=> 1,:is_default => 1})
  end
end
