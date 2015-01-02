# CL: required to allow state_machine to work correctly in Rails 4
module StateMachine
  module Integrations
     module ActiveModel
        public :around_validation
     end
  end
end