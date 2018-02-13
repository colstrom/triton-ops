
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'redis'     # MIT License
require 'json'      # Ruby Standard Library

require_relative 'support/type_coercion'
require_relative 'resources'

module TritonOps
  class Snapshot
    include ::Contracts::Core
    include ::Contracts::Builtin
    include ::TritonOps::Support::TypeCoercion

    def initialize(headnode, timestamp, **options)
      @headnode  = headnode
      @timestamp = Coerce.to_time timestamp
      @namespace = options.fetch(:namespace) { '' }
      self
    end

    attr_reader :headnode, :timestamp

    def prefix
      @prefix ||= "#{@namespace}/headnode/#{headnode}/snapshot/#{timestamp.iso8601}"
    end

    def array_from_json_at_redis_prefix
      raise TypeError unless type = ::TritonOps::Resource.constants.find { |name| name.to_s.downcase == __callee__.to_s.chop }

      if instance_variable_defined? "@#{__callee__}"
        instance_variable_get "@#{__callee__}"
      else
        instance_variable_set(
          "@#{__callee__}",
            JSON.parse(
              (redis.get("#{prefix}/#{__callee__}") || '[]'),
              symbolize_names: true).map { |spec| ::TritonOps::Resource.const_get(type).new spec })
      end
    end

    alias images    array_from_json_at_redis_prefix
    alias platforms array_from_json_at_redis_prefix
    alias servers   array_from_json_at_redis_prefix
    alias users     array_from_json_at_redis_prefix
    alias vms       array_from_json_at_redis_prefix

    private

    def redis
      @redis ||= Redis.new
    end
  end
end
