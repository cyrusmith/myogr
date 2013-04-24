module RecordsHelper
  def format_to_clock_time(time)
    Russian::strftime(time, '%H:%M')    
  end
  def format_to_plain_time(time)
    Russian::strftime(time, '%H%M')    
  end    
end
