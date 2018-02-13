
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'json'      # Ruby Standard Library
require 'redis'     # MIT License
require 'time'      # Ruby Standard Library

module TritonOps
  class Snapshot
    class Collector
      include ::Contracts::Core
      include ::Contracts::Builtin

      Contract String, KeywordArgs[namespace: Optional[String]] => Collector
      def initialize(headnode, **options)
        @headnode  = headnode
        @namespace = options.fetch(:namespace) { '' }
        self
      end

      attr_reader   :headnode
      attr_accessor :namespace

      COMMANDS = {
        images:    %q(/opt/smartdc/bin/sdc-imgadm list --json),
        platforms: %q(/opt/smartdc/bin/sdcadm platform list --json),
        servers:   %q(/opt/smartdc/bin/sdc-server lookup -j),
        timestamp: %q(/usr/xpg4/bin/date +%s),
        users:     %q(/opt/smartdc/bin/sdc-useradm search --json 'uuid=*'),
        vms:       %q(/opt/smartdc/bin/sdc-vmadm list --json),
      }

      TARGETS = COMMANDS.keys - %i(timestamp)

      Contract RespondTo[:to_s], String => Any
      def record(key, value)
        snapshot = timestamp.iso8601
        redis.multi do
          redis.set   "#{namespace}/headnode/#{headnode}/snapshot/#{snapshot}/#{key}", value
          redis.sadd  "#{namespace}/headnode/#{headnode}/snapshot/#{snapshot}", key
          redis.sadd "#{namespace}/headnode/#{headnode}/snapshots", snapshot
          redis.sadd  "#{namespace}/headnodes", headnode
        end
      end

      Contract RespondTo[:to_s], Any => Any
      def record(key, value)
        record key, JSON.dump(value)
      end

      # Most of the commands we need to execute output a JSON array.
      def array_from_json_output_of_remote_command
        if instance_variable_defined? "@#{__callee__}"
          instance_variable_get "@#{__callee__}"
        else
          instance_variable_set(
            "@#{__callee__}",
            JSON.parse(execute_remote!(command(__callee__))))
        end
      end

      alias images    array_from_json_output_of_remote_command
      alias platforms array_from_json_output_of_remote_command
      alias servers   array_from_json_output_of_remote_command
      alias users     array_from_json_output_of_remote_command
      alias vms       array_from_json_output_of_remote_command

      # This one needs special handling, since it outputs one JSON object per line.
      def servers
        @servers ||= execute_remote!(command(:servers)).each_line.map { |line| JSON.parse line }
      end

      # This one needs special handling, since there is no JSON involved.
      Contract None => Time
      def timestamp
        @timestamp ||= Time.at(
          execute_remote!(command(:timestamp)).to_i).utc
      end

      private

      def command(target)
        COMMANDS.fetch target
      end

      def execute_remote!(command)
        %x(ssh #{headnode} -- #{command})
      end

      def redis
        @redis ||= Redis.new
      end
    end
  end
end
