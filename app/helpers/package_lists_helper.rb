module PackageListsHelper
  def point
    @point
  end

  def render_row(package_list)
    render 'list_row', data: PackageListDatarow.new(package_list)
  end
end
