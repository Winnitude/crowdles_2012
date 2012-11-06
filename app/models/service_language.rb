class ServiceLanguage
  include Mongoid::Document
  before_save :change_default
  field :is_active, :type => Integer
  field :local_name, :type => String
  field :english_name, :type => String
  field :iso_code, :type => String
  field :is_default, :type => Integer

  def self.make_language_active_and_default(language)
    lang = where(:english_name => language).first
    lang.update_attributes({:is_active=> 1,:is_default => 1})
  end
  def change_default
    logger.info "inside change default"

    if self.is_default == 1
     previous_default=ServiceLanguage.where(:is_default => 1).first
      if previous_default.present? && previous_default != self
        previous_default.is_default = 0
        previous_default.save
      end
    end
  end
end



