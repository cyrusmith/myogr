class CreatePackageListJob
  def self.execute
    points = Distribution::Point.all
    points.each do |point|
      date = Date.today + 90.days
      puts "Point: #{point}. Checking date #{date}"
      if point.package_lists.includes(:schedule).where(schedule: {date: date}).count == 0
        puts 'Package list not found. Creating...'
        if (point.work_schedule.in? 1..4)
          copyList = point.package_lists.includes(:schedule).where(schedule: {date: date - point.work_schedule.weeks})
          copyList.each do |list|
            new_list = list.dup
            new_list.date = date
            list.appointments.each { |app| new_list.appointments << app.dup }
            new_list.save
          end
        else
          point.default_package_list_amount.times do
            point.package_lists.create(date: date, package_limit: point.default_day_package_limit)
          end
        end
        puts 'Created!'
      end
    end
  end
end