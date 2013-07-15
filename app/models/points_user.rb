class PointsUser < ActiveRecord::Base
  attr_accessible :employee_id

  belongs_to :user, foreign_key: :employee_id
  belongs_to :point, class_name: 'Distribution::Point'
end