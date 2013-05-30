class CreatePackageListJob
  def self.execute
    points = Distribution::Point.all
    points.each do |point|
      date = Date.today + 90.days
      puts "Point: #{point}. Checking date #{date}"
      if point.package_lists.where(date: date).count == 0
        puts "Package list not found. Creating..."
        point.package_lists.create(date: date, package_limit: point.default_day_package_limit)
        puts "Created!"
      end
    end
  end
end