require 'spec_helper'

describe Distribution::PackageList do
  before(:all) do
    @point = Distribution::Point.create!(head_user:1)
    puts "Point value: #{@point.default_day_package_limit}"
  end
  it 'should set default package limit from distribution point if nothing set in creation' do
    package_list = @point.package_lists.create(date: Date.today)
    puts package_list
    package_list.package_limit == @point.default_day_package_limit
    puts "Package list value: #{package_list.package_limit}"
  end
  it 'should set default package limit from creation hash' do
    package_limit_value = 50
    puts "Point value: #{@point.default_day_package_limit}"
    package_list = @point.package_lists.create(date: Date.today, package_limit: package_limit_value)
    puts "Package list value: #{package_list.package_limit}"
    package_list.package_limit == package_limit_value
  end
  it "get_info method should return correct values" do
    package_list = @point.package_lists.create(date: Date.today, is_day_off: true)
    package_list.get_info[1] == 'day-off'
  end
end
