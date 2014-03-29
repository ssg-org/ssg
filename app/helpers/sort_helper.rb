module SortHelper
  def sort_by(column)
    url_for(params.merge({sort: column}))
  end
end
