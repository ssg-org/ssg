module SoftDelete
  
  def delete!
    self.update_attribute('deleted', true)
  end

  def deleted?
    !!read_attribute(:deleted)
  end

end