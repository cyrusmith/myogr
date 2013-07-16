module ScheduleExtension
  def acts_as_schedule_extension
    include InstanceMethods
    ############################ Class methods ################################
    has_one :schedule, as: :extension, autosave: true, dependent: :destroy
    alias_method_chain :schedule, :build

    schedule_attributes = Schedule.content_columns.map(&:name) #<-- gives access to all columns of Business
    # define the attribute accessor method
    def extension_attr_accessor(*attribute_array)
      attribute_array.each do |att|
        define_method(att) do
          schedule.send(att)
        end
        define_method("#{att}=") do |val|
          schedule.send("#{att}=", val)
        end
      end
    end

    #TODO нужно добавлять параметры в массив для mass-assignment, чтобы в модели не прописывать attr_accessible для полей Schedules

    extension_attr_accessor *schedule_attributes #<- delegating the attributes
  end

  module InstanceMethods
    def schedule_with_build
      schedule_without_build || build_schedule
    end
  end
end