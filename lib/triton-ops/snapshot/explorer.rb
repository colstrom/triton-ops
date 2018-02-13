
# -*- ruby -*-

require 'redis'      # MIT License
require 'tty-prompt' # MIT License
require_relative 'catalog'

module TritonOps
  class Snapshot
    class Explorer
      def initialize(**options)
        @namespace = options.fetch(:namespace) { '' }
        self
      end

      def headnode
        return unless headnodes?
        prompt.select 'Which headnode?', catalog.headnodes
      end

      def snapshot(headnode)
        return unless snapshots? headnode
        prompt.select 'Which snapshot?', catalog.snapshots(headnode)
      end

      def browse
        h = headnode
        s = snapshot h
        [h, s]
      end

      private

      def fatal(message, status = 1)
        error message
        exit status
      end

      def error(message)
        pastel.red message
      end

      def headnodes?
        not catalog.headnodes.empty?
      end

      def snapshots?(headnode)
        not catalog.snapshots(headnode).empty?
      end

      def pastel
        @pastel ||= Pastel.new
      end

      def catalog
        @catalog ||= Catalog.new namespace: @namespace
      end

      def prompt
        @prompt ||= ::TTY::Prompt.new
      end

      def redis
        @redis ||= ::Redis.new
      end
    end
  end
end

E = TritonOps::Snapshot::Explorer.new
