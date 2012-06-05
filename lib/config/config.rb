module Config
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/configuration.yml")[Rails.env]
  
  def self.get(section, name, default='')
    return APP_CONFIG[section.to_s][name.to_s] || default
  end
  
end