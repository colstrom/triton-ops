
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License

module TritonOps
  module Support
    module Feature
      module HashFromInitializationContract
        include ::Contracts::Core

        def to_h
          self.class.__contracts_engine
            .decorated_methods_for(:instance_methods, :initialize)
            .flat_map(&:args_contracts)
            .flat_map(&:keys)
            .map    { |k| [k, public_send(k)] }
            .reject { |_, v| v.nil? }
            .map    { |k, v| [k, (v.respond_to?(:iso8601) ? v.iso8601 : v)] }
            .to_h
        end
      end
    end
  end
end
