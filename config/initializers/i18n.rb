# Monkey patch I18n to store script for handling latinic and cyrillic alphabets
module I18n
	class<< self
		def script
			Thread.current[:i18n_script]
		end

	  def script=(value)
	    Thread.current[:i18n_script] = value.to_sym rescue nil
	  end

		def default_script
			Thread.current[:i18n_default_script] || :latin
		end

	  def default_script=(value)
	    Thread.current[:i18n_default_script] = value.to_sym rescue nil
	  end

	  def cyrillic?
	  	self.script == :cyrillic
	  end
	end
end