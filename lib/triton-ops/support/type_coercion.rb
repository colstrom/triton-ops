
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'date'      # Ruby Standard Library
require 'time'      # Ruby Standard Library

module TritonOps
  module Support
    module TypeCoercion
      module Coerce
        include ::Contracts::Core
        include ::Contracts::Builtin

        Contract String => Time
        def self.to_time(string)
          if string =~ /^[[:digit:]]+$/
            self.to_time string.chars.take(10).join.to_i
          else
            Time.parse(string).utc
          end
        end

        Contract Integer => Time
        def self.to_time(integer)
          if integer.digits.length > 10
            self.to_time integer.to_s
          else
            Time.at(integer).utc
          end
        end

        Contract DateTime => Time
        def self.to_time(datetime)
          datetime.to_time
        end

        Contract Time => Time
        def self.to_time(time)
          time
        end

        Contract Enum[%w(true false)] => Bool
        def self.to_bool(string)
          case string
          when 'true'
            true
          when 'false'
            false
          end
        end

        Contract Bool => Bool
        def self.to_bool(bool)
          bool
        end

        Contract Time => String
        def self.to_string(time)
          time.utc.iso8601
        end

        Contract RespondTo[:to_s] => String
        def self.to_string(object)
          object.to_s
        end
      end
    end
  end
end
