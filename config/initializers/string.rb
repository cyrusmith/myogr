class String
  def to_class
    Kernel.const_get self
  rescue NameError
    nil
  end

  def classname?
    true if self.to_class
  rescue NameError
    false
  end
end