class Record
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Origin::Queryable
  include Tenacity

  default_scope asc(:record_date)

  t_belongs_to :user
  belongs_to :admin_salon_employee, :class_name => 'Admin::Salon::Employee'

  field :user, type: String
  field :record_date, type: Date
  field :record_time, type: Time
  field :procedures, type: Array
  field :employee, type: String
  field :total_duration, type: Float
  field :group, type: String

  before_save :count_total_duration

  # Округлять до 0,5 или целого числа
  def count_total_duration
    self.total_duration = 0
    self.procedures.each do |procedure|
      self.total_duration += Admin::Salon::Procedure.find(procedure).duration
    end
  end
end
