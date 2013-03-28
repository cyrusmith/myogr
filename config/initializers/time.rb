class Time
  def split_by(split_by, end_time)
    [self].tap do |array|
      array << array.last + split_by while array.last < end_time
    end
  end
end