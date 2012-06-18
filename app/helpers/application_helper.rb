module ApplicationHelper
    def clear_params (new_map)
        cleared = params.clone
        cleared.delete(:action)       
        cleared.delete(:controller)
        return cleared.merge(new_map)
    end
end
