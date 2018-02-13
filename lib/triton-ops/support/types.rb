
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'date'      # Ruby Standard Library
require 'time'      # Ruby Standard Library

module TritonOps
  module Support
    module Types
      module Castable
        Time   = ::Contracts::Or[::String, ::Integer, ::DateTime, ::Time]
        Bool   = ::Contracts::Or[::Contracts::Enum[*%w(true false)], ::TrueClass, ::FalseClass]
        String = ::Contracts::RespondTo[:to_s]
      end

      CompressionAlgorithm = ::Contracts::Enum[*(%w(on off gzip lz4 lzjb zle) + (1..9).map { |n| "gzip-#{n}" })]
    end
  end
end
