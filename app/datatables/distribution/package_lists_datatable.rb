module Distribution
  class PackageListsDatatable
    delegate :params, :h, :link_to, :number_to_currency, :point, to: :@view

    def initialize(view)
      @view = view
    end

    def as_json(options = {})
      {
          sEcho: params[:sEcho].to_i,
          iTotalRecords: point.package_lists.count,
          iTotalDisplayRecords: package_lists.total_count,
          aaData: data
      }
    end

    private

    def data
      package_lists.map do |list|
        [
            h(list.date),
            h(list.packages.count),
            h(list.state.present? ? list.state : '')
        ]
      end
    end

    def package_lists
      @package_lists ||= fetch_package_lists
    end

    def fetch_package_lists
      products = point.package_lists.order_by("#{sort_column} #{sort_direction}")
      products = products.page(page).per(per_page)
      if params[:sSearch].present?
        products = products.where(date: "%#{params[:sSearch]}%")
      end
      products
    end

    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
      columns = %w[date count state]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == 'desc' ? 'desc' : 'asc'
    end
  end
end