module ApplicationHelper
    def clear_params(new_map = {}, del_params = [ :action, :controller ])
        cleared = params.clone
        del_params.each { |param| cleared.delete(param) }
        return cleared.merge(new_map)
    end
    
    def ssg_button(label, attrs = {})
      a_atrs = ""
      
      # attrs[:class] = "#{attrs[:class]} btn_green"
      attrs.map { |k,v| 
        a_atrs << "#{k.to_s}=\"#{v.to_s}\" "
      }
      puts a_atrs
      return "<a #{a_atrs}><div class=\"btn_green\">#{label}</div></a>".html_safe;
    end
end
