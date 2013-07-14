class PointsUser < ActiveRecord::Base
  belongs_to :user, foreign_key: :employee_id
  belongs_to :point, class_name: 'Distribution::Point'
end