module Distribution
  class MobileIssuePointsController < PointsController

    def get_point_type
      MobileIssuePoint
    end

  end
end