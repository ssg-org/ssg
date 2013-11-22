class TranslatedBase < ActiveRecord::Base
  self.abstract_class = true

  after_initialize :transliterate
	before_save :transliterate_to_latin

	protected
		def transliterate_to_latin
			attributes.each do |name, value|
				value.to_lat! if value.is_a?(String) rescue nil
			end
		end

		def transliterate
			if I18n.cyrillic?
				attributes.each do |name, value|
					value.to_cyr! if value.is_a?(String) && name != "slug" rescue nil
				end
			end
		end
end