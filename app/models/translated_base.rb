class TranslatedBase < ActiveRecord::Base
  self.abstract_class = true

  TRANSLATED_ATTRIBUTES = %w(name description text first_name last_name)

  after_find :transliterate
	before_save :transliterate_to_latin

	protected
		def transliterate_to_latin
			attributes.each do |name, value|
				value.to_lat! if !value.nil? and value.is_a?(String)
			end
		end

		def transliterate
			if I18n.cyrillic?
				attributes.each do |name, value|
					value.to_cyr! if !value.nil? and value.is_a?(String) and TRANSLATED_ATTRIBUTES.include?(name)
				end
			end
		end
end