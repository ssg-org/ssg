module Config
  class Configuration
    
	def self.reload()
		puts "Starting with #{Rails.env} configuration :"

		@@cache = YAML::load(File.read('config/configuration.yml'))

		puts "config :  #{@@cache}"

		# check if per-developer configuration exists (this is not included in git!!!!!)
		if (File.exist?('config/configuration.local.yml'))
		  locale = YAML::load(File.read('config/configuration.local.yml'))

		  # copy local -> @@cache with overwrite
		  locale.each do |k1, v1|
		    v1.each do |k2, v2|
		      v2.each do |k3, v3|
		      	@@cache[k1] = v1 		if @@cache[k1].nil?
		      	@@cache[k1][k2] = v2 	if @@cache[k1][k2].nil?
		      	@@cache[k1][k2][k3] = v3
		      end
		    end
		  end
		end
	end
    
  def self.get(group, name, default="")

    return unless @@cache[Rails.env] 

    rval = @@cache[Rails.env][group.to_s][name.to_s]
    if (rval.nil?)
    	return default
    end
    return rval
  end
  
  def self.get_root(server)
    return @@cache[server]
  end

end
end