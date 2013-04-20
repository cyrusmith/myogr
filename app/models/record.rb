class Record
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Tenacity

  default_scope asc(:record_date)

  t_belongs_to :user
  belongs_to :admin_salon_employee, :class_name => 'Admin::Salon::Employee'

  field :user_id, type: Integer
  field :contact_phone, type: String
  field :contact_name, type: String
  field :record_date, type: Date
  field :record_time, type: Time
  field :procedure, type: String
  field :employee, type: String
  field :total_duration, type: Float, default: 0
  field :group, type: String

  before_save :total_duration

  # Округлять до 0,5 или целого числа
  def total_duration
    self.total_duration = Admin::Salon::Procedure.find(self.procedure).duration
  end
end
