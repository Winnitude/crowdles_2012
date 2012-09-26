class ServiceCountry
  include Mongoid::Document
  before_save :change_default
  field :is_active, :type => Integer
  field :is_default, :type => Integer
  field :user_country, :type => Integer
  field :country_local_name, :type => String
  field :country_english_name, :type => String
  field :iso_code, :type => String

  def change_default
    logger.info "inside change default"

      if self.is_default == 1
        previous_default=ServiceCountry.where(:is_default => 1).first
        if previous_default.present? && previous_default != self
          previous_default.is_default = 0
          previous_default.save
        end
      end
  end

  def self.make_country_default(country)
    country = where(:country_english_name => country).first
    country.update_attribute(:is_default, 1)
  end
end
