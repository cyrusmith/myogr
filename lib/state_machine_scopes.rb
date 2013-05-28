module StateMachineScopes
  class MethodAlreadyDefinedError < StandardError; end
  class StateMachineNotFoundError < StandardError; end
  class NoStateMachineNotFoundError < StandardError; end

  module ClassMethods
    def all_states(machine = :state)
      machine = machine.to_sym
      if state_machines.key?(machine)
        state_machines[machine.to_sym].states.keys.compact.sort
      else
        raise StateMachineNotFoundError.new(%Q{"#{self.name}" does not seem to have a state machine called "#{machine}".})
      end
    end

    def state_machine_scopes(*which)
      options = which.last.is_a?(Hash) ? which.pop : {}
      prefix = options.delete(:prefix)

      if which.any?
        which.each do |machine_name|
          define_scopes_for(machine_name, prefix)
        end
      else
        state_machines.keys.each do |machine_name|
          define_scopes_for(machine_name, prefix)
        end
      end
    end

    private

    def define_scopes_for(machine_name, prefix)
      state_machines[machine_name.to_sym].states.keys.compact.each do |state|
        scope_name = [prefix, machine_name, state].compact.join('_')
        debugger if scope_name.to_s == 'state'
        if self.respond_to? scope_name
          raise MethodAlreadyDefinedError.new("Already defined method called \"#{scope_name}\"")
        end
        self.class_eval do
          scope :"#{scope_name}", where(:state => state)
        end
      end
    end

  end

  def self.included(klass)
    if klass.respond_to?(:state_machines)
      klass.extend(ClassMethods)
    else
      raise NoStateMachineNotFoundError.new(%Q{"#{klass.name}" does not seem to have any state machines.})
    end
  end

end