class PointsUser < ActiveRecord::Base
  include Tenacity

  attr_accessible :employee_id

  t_belongs_to :user, foreign_key: :employee_id
  belongs_to :point, class_name: 'Distribution::Point'
end