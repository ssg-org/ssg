module ApplicationHelper
    def clear_params(new_map = {}, del_params = [ :action, :controller ])
        cleared = params.clone
        del_params.each { |param| cleared.delete(param) }
        return cleared.merge(new_map)
    end
    
    def ssg_button(label, attrs = {}, sattrs={}, extend_class="")
      a_atrs = ""
      s_atrs = ""
      
      # attrs[:class] = "#{attrs[:class]} btn_green"
      attrs.map { |k,v| a_atrs << "#{k.to_s}=\"#{v.to_s}\" " }
      sattrs.map { |k,v| s_atrs << "#{k.to_s}=\"#{v.to_s}\" " }
      
      return "<a #{a_atrs}><span class=\"btn_green #{extend_class}\"  #{s_atrs}>#{label}</span></a>".html_safe;
    end

    def ssg_button_v2(label, attrs = {}, sattrs={}, extend_class="", disable_anchor=false)
      a_atrs = ""
      s_atrs = ""
      
      # attrs[:class] = "#{attrs[:class]} btn_green"
      attrs.map { |k,v| a_atrs << "#{k.to_s}=\"#{v.to_s}\" " }
      sattrs.map { |k,v| s_atrs << "#{k.to_s}=\"#{v.to_s}\" " }
      
      button_html = "<span class=\"btn_green_v2 #{extend_class}\"  #{s_atrs}>#{label}</span>"

      if disable_anchor
        return button_html.html_safe
      else
        return "<a #{a_atrs}>#{button_html}</a>".html_safe;
      end
    end

    def collect_city_names()
      cities = City.all.sort { |a,b| a.name <=> b.name }
      cities.collect { |c| [c.name, c.id ] }
    end
end
