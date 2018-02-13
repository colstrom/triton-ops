
# -*- ruby -*-

require 'redis' # MIT License
require_relative '../snapshot'

module TritonOps
  class Snapshot
    class Catalog
      def initialize(**options)
        @namespace = options.fetch(:namespace) { '' }
        self
      end

      attr_accessor :namespace

      def headnodes
        redis.smembers("#{namespace}/headnodes") || []
      end

      def snapshots(headnode)
        return [] unless headnodes.include? headnode
        redis.smembers("#{namespace}/headnode/#{headnode}/snapshots") || []
      end

      def properties(headnode, snapshot)
        return [] unless snapshots(headnode).include? snapshot
        redis.smembers("#{namespace}/headnode/#{headnode}/snapshot/#{snapshot}") || []
      end

      def get(headnode, snapshot, property = :all)
        TritonOps::Snapshot.new headnode, snapshot, namespace: @namespace
      end

      private

      def redis
        @redis ||= Redis.new
      end
    end
  end
end
