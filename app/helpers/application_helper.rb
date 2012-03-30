module ApplicationHelper
  def menu_item(index, label, description, color, options = {})
    options = { :start_height => 120, :height => 50, :active => false }.merge(options)
    
    top = options[:start_height] + index * options[:height]
    left_override = options[:active] ? 'left-menu-active' : ''
    
    "<a href=\"#{root_path(:menu=>index)}\">
  		<div class=\"#{color} left-menu-label\" style=\"top:#{top}px;\">
  			#{label}
  		</div>
  		<div class=\"#{color} left-menu-description #{left_override}\" style=\"top:#{top}px;\">
  			#{description}
  		</div>
  	</a>".html_safe
  end
end
