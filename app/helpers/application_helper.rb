module ApplicationHelper
    def clear_params(new_map = {}, del_params = [ :action, :controller ])
        cleared = params.clone
        del_params.each { |param| cleared.delete(param) }
        return cleared.merge(new_map)
    end
end
