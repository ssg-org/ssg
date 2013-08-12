module ApplicationHelper
    def clear_params(new_map = {}, del_params = [ :action, :controller ])
        cleared = params.clone
        del_params.each { |param| cleared.delete(param) }
        return cleared.merge(new_map)
    end
    
    def ssg_button(label, attrs = {}, sattrs={})
      a_atrs = ""
      s_atrs = ""
      
      # attrs[:class] = "#{attrs[:class]} btn_green"
      attrs.map { |k,v| a_atrs << "#{k.to_s}=\"#{v.to_s}\" " }
      sattrs.map { |k,v| s_atrs << "#{k.to_s}=\"#{v.to_s}\" " }
      puts a_atrs
      return "<a #{a_atrs}><span class=\"btn_green\"  #{s_atrs}>#{label}</span></a>".html_safe;
    end

    def collect_city_names()
      cities = City.all.sort { |a,b| a.name <=> b.name }
      cities.collect { |c| [c.name, c.id ] }
    end
end
