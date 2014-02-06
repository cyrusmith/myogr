module Distribution
  class IssuePointsController < PointsController

    def get_point_type
      IssuePoint
    end
  end
end