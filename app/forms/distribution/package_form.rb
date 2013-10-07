module Distribution
  class PackageForm
    delegate :errors, :code, to: :@package

    attr_reader :package

    def initialize(package, user, option={})
      @package = package
      @user = user
      @point = option[:point] || package.package_list.try(:point) || (points.first if points.count == 1)
    end

    def points
      Point.all
    end

    def chosen_point
      @point
    end

    def new?
      @package.new_record?
    end

    def shown_items
      PackageItem.where(user_id: @user.id, is_next_time_pickup: false).accepted
    end

    def days_info
      prepare_for_json do
        if @point.nil?
          points.first.get_days_info(@user.case?) if points.count == 1
        else
          @point.get_days_info(@user.case?)
        end
      end
    end

    def package_list
      new? ? nil : @package.package_list
    end

    protected

    def new_db_items(recorded_items)
      recorded_ids = recorded_items.map(&:item_id)
      Distributor.in_distribution_for_user(@user).delete_if { |item| item.id.in? recorded_ids }
    end

    def prepare_for_json
      result = yield() || {}
      result.inject Hash.new, :merge
    end

  end
end