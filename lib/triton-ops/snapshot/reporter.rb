
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'tty-table' # MIT License

require_relative '../snapshot'

module TritonOps
  class Snapshot
    class Reporter
      include ::Contracts::Core
      include ::Contracts::Builtin

      Format = Enum[*%i(basic ascii unicode)]

      Contract ::TritonOps::Snapshot, KeywordArgs[
        :exclude => Optional[ArrayOf[String]],
        :format  => Optional[Format],
        :targets => Optional[ArrayOf[String]],
      ] => Reporter
      def initialize(snapshot, **options)
        @snapshot = snapshot
        @options  = options
        self
      end

      Contract None => Any
      def usage
        users.each do |user|
          uuid  = user.uuid
          ram   = memory(uuid)  || 0
          disk  = storage(uuid) || 0
          next if [ram, disk].all?(&:zero?)

          login = user.login
          cn    = user.cn

          puts "# #{login} (#{cn}) has (#{ram} MB of Memory) and (#{disk} MB of Storage) reserved"

          puts TTY::Table.new(
                 header: ['VM Alias', 'Memory', 'Storage', 'Creation Date'],
                 rows: owned_by(uuid)
                   .sort_by { |vm| vm.create_timestamp }
                   .map do |vm|
                   [
                     vm.alias,
                     vm.max_physical_memory,
                     (vm.disks ? vm.disks.map { |disk| disk.size }.reduce(:+) : 0),
                     vm.create_timestamp.iso8601
                   ]
                 end).render(format)
        end
      end

      private

      def format
        @options.fetch(:format) { :basic }
      end

      def exclusions
        @options.fetch(:exclude) { [] }
      end

      def targets
        @options.fetch(:targets) { @snapshots.users.map { |user| user.login } }
      end

      def users
        @snapshot.users
          .reject { |user| exclusions.include? user.login }
          .reject { |user| @snapshot.vms.none? { |vm| vm.owner_uuid == user.uuid } }
          .select { |user| targets.empty? or targets.include?(user.login) }
      end

      def owned_by(owner_uuid)
        @snapshot
          .vms
          .select { |vm| vm.owner_uuid == owner_uuid }
      end

      def memory(owner_uuid)
        owned_by(owner_uuid)
          .map { |vm| vm.max_physical_memory }
          .reduce(:+)
      end

      def storage(owner_uuid)
        owned_by(owner_uuid)
          .reject { |vm| vm.disks.empty? }
          .map { |vm| vm.disks
                   .map { |disk| disk.size }
                   .reduce(:+) }
          .reduce(:+)
      end
    end
  end
end
