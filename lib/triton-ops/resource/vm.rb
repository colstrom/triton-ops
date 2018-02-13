
# -*- ruby -*-

require_relative 'virtual_machine'

module TritonOps
  module Resource
    module VM
      def self.new(**options)
        TritonOps::Resource::VirtualMachine.new options
      end
    end
  end
end
