class ServiceLanguage
  include Mongoid::Document
  field :is_active, :type => Integer
  field :local_name, :type => String
  field :english_name, :type => String
  field :iso_code, :type => String

  def self.make_language_active(language)
    lang = where(:english_name => language).first
    lang.update_attribute(:is_active, 1)
  end
end
