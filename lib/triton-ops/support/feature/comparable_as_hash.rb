
# -*- ruby -*-

module TritonOps
  module Support
    module Feature
      module ComparableAsHash
        def ==(other)
          (other.respond_to?(:to_h) && (self.to_h == other.to_h)) || false
        end
      end
    end
  end
end
