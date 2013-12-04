class PackageListDatarow

  def initialize(package_list)
    @package_list = package_list
    @packages = @package_list.packages
  end

  def package_list
    @package_list
  end

  def point
    @package_list.point
  end

  def package_limit
    @package_list.package_limit
  end

  def total_packages
    @packages.count
  end

  def limitable_packages
    @package_list.count_limited_packages
  end

  def case_packages
    @packages.select{|package| package.case_active? }.count
  end

  def collected_packages
    @packages.select{|package| package.collected? }.count
  end

  def issued_packages
    @packages.select{|package| package.completed? }.count
  end

end