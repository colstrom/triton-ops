
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'date'      # Ruby Standard Library
require 'time'      # Ruby Standard Library

require_relative '../support/feature/comparable_as_hash'
require_relative '../support/feature/hash_from_initialization_contract'
require_relative '../support/type_coercion'
require_relative '../support/types'
require_relative 'virtual_machine/disk'
require_relative 'virtual_machine/network_interface'

module TritonOps
  module Resource
    class VirtualMachine
      include ::Contracts::Core
      include ::Contracts::Builtin
      include ::TritonOps::Support::Feature::ComparableAsHash
      include ::TritonOps::Support::Feature::HashFromInitializationContract
      include ::TritonOps::Support::Types
      include ::TritonOps::Support::TypeCoercion

      Brand     = Enum[*%w(joyent joyent-minimal lx kvm)]
      State     = Enum[*%w(configured down failed incomplete provisioning ready receiving running shutting_down stopped stopping)]
      ZoneState = Enum[*%w(configured down incomplete installed ready running shutting_down)]
      CPU       = Enum[*%w(qemu64 host)]
      Type      = Enum[*%w(OS LX KVM)]

      Contract ({
                  :alias               => String,
                  :billing_id          => String,
                  :brand               => Brand,
                  :cpu_shares          => Integer,
                  :create_timestamp    => Castable::Time,
                  :customer_metadata   => HashOf[Or[String, Symbol], Any],
                  :datasets            => ArrayOf[Any],
                  :internal_metadata   => HashOf[Or[String, Symbol], Any],
                  :last_modified       => Castable::Time,
                  :limit_priv          => Or[String, ArrayOf[String]],
                  :max_locked_memory   => Integer,
                  :max_lwps            => Integer,
                  :max_physical_memory => Integer,
                  :max_swap            => Integer,
                  :nics                => ArrayOf[Or[HashOf[Or[String, Symbol], Any], NetworkInterface]],
                  :owner_uuid          => String,
                  :platform_buildstamp => Castable::Time,
                  :quota               => Integer,
                  :ram                 => Integer,
                  :resolvers           => ArrayOf[String],
                  :server_uuid         => String,
                  :snapshots           => ArrayOf[Any],
                  :state               => State,
                  :tags                => HashOf[Or[String, Symbol], Any],
                  :uuid                => String,
                  :zfs_filesystem      => String,
                  :zfs_io_priority     => Integer,
                  :zone_state          => ZoneState,
                  :zonepath            => String,
                  :zpool               => String,

                  :autoboot            => Maybe[Bool],
                  :boot_timestamp      => Maybe[Castable::Time],
                  :cpu_cap             => Maybe[Integer],
                  :cpu_type            => Maybe[CPU],
                  :destroyed           => Maybe[Bool],
                  :disks               => Maybe[ArrayOf[Or[HashOf[Symbol, Any], Disk]]],
                  :firewall_enabled    => Maybe[Bool],
                  :pid                 => Maybe[Integer],
                  :vcpus               => Maybe[Integer],
                }) => VirtualMachine
      def initialize(**options)
        @options = options
        self.to_h
        remove_instance_variable '@options'
        self
      end

      #######################
      # Required Properties #
      #######################

      Contract None => String
      def alias
        @alias ||= @options.fetch :alias
      end

      Contract None => Brand
      def brand
        @brand ||= @options.fetch :brand
      end

      Contract None => String
      def billing_id
        @billing_id ||= @options.fetch :billing_id
      end

      Contract None => Integer
      def cpu_shares
        @cpu_shares ||= @options.fetch :cpu_shares
      end

      Contract None => Time
      def create_timestamp
        @create_timestamp ||= Coerce.to_time @options.fetch :create_timestamp
      end

      Contract None => HashOf[String, Any]
      def customer_metadata
        @customer_metadata ||= @options.fetch(:customer_metadata).transform_keys(&:to_s)
      end

      Contract None => Maybe[ArrayOf[Any]]
      def datasets
        @datasets ||= (@options || {}).fetch(:datasets, nil)
      end

      Contract None => HashOf[String, Any]
      def internal_metadata
        @internal_metadata ||= @options.fetch(:internal_metadata).transform_keys(&:to_s)
      end

      Contract None => Time
      def last_modified
        @last_modified ||= Coerce.to_time @options.fetch :last_modified
      end

      Contract None => ArrayOf[String]
      def limit_priv
        @limit_priv ||= case raw = @options.fetch(:limit_priv)
                        when String
                          raw.split(',')
                        when Array
                          raw
                        end
      end

      Contract None => Integer
      def max_locked_memory
        @max_locked_memory ||= @options.fetch :max_locked_memory
      end

      Contract None => Integer
      def max_lwps
        @max_lwps ||= @options.fetch :max_lwps
      end

      Contract None => Integer
      def max_physical_memory
        @max_physical_memory ||= @options.fetch :max_physical_memory
      end

      Contract None => Integer
      def max_swap
        @max_swap ||= @options.fetch :max_swap
      end

      Contract None => ArrayOf[NetworkInterface]
      def nics
        @nics ||= @options.fetch(:nics).map { |nic| NetworkInterface.new nic.to_h }
      end

      Contract None => String
      def owner_uuid
        @owner_uuid ||= @options.fetch :owner_uuid
      end

      Contract None => Time
      def platform_buildstamp
        @platform_buildstamp ||= Coerce.to_time @options.fetch :platform_buildstamp
      end

      Contract None => Integer
      def quota
        @quota ||= @options.fetch :quota
      end

      Contract None => Integer
      def ram
        @ram ||= @options.fetch :ram
      end

      Contract None => ArrayOf[String]
      def resolvers
        @resolvers ||= @options.fetch :resolvers
      end

      Contract None => String
      def server_uuid
        @server_uuid ||= @options.fetch :server_uuid
      end

      Contract None => ArrayOf[Any]
      def snapshots
        @snapshots ||= @options.fetch :snapshots
      end

      Contract None => State
      def state
        @state ||= @options.fetch :state
      end

      Contract None => HashOf[Symbol, Any]
      def tags
        @tags ||= @options.fetch(:tags).transform_keys(&:to_sym)
      end

      Contract None => String
      def uuid
        @uuid ||= @options.fetch :uuid
      end

      Contract None => String
      def zfs_filesystem
        @zfs_filesystem ||= @options.fetch :zfs_filesystem
      end

      Contract None => Integer
      def zfs_io_priority
        @zfs_io_priority ||= @options.fetch :zfs_io_priority
      end

      Contract None => ZoneState
      def zone_state
        @zone_state ||= @options.fetch :zone_state
      end

      Contract None => String
      def zonepath
        @zonepath ||= @options.fetch :zonepath
      end

      Contract None => String
      def zpool
        @zpool ||= @options.fetch :zpool
      end

      #######################
      # Optional Properties #
      #######################

      Contract None => Maybe[Bool]
      def autoboot
        @autoboot ||= (@options || {}).fetch(:autoboot, nil)
      end

      Contract None => Maybe[Time]
      def boot_timestamp
        @boot_timestamp ||= case raw = (@options || {}).fetch(:boot_timestamp, nil)
                            when nil
                              nil
                            else
                              Coerce.to_time raw
                            end
      end

      Contract None => Maybe[Integer]
      def cpu_cap
        @cpu_cap ||= (@options || {}).fetch(:cpu_cap, nil)
      end

      Contract None => Maybe[CPU]
      def cpu_type
        @cpu_type ||= (@options || {}).fetch(:cpu_type, nil)
      end

      Contract None => Maybe[Bool]
      def destroyed
        @destroyed ||= (@options || {}).fetch(:destroyed, nil)
      end

      Contract None => Maybe[ArrayOf[Disk]]
      def disks
        @disks ||= @options.fetch(:disks, []).map { |disk| Disk.new disk.to_h }
      end

      Contract None => Maybe[Bool]
      def firewall_enabled
        @firewall_enabled ||= (@options || {}).fetch(:firewall_enabled, nil)
      end

      Contract None => Maybe[Integer]
      def pid
        @pid ||= (@options || {}).fetch(:pid, nil)
      end

      Contract None => Maybe[Integer]
      def vcpus
        @vcpus ||= (@options || {}).fetch(:vcpus, nil)
      end

      ###########
      # SmartOS #
      ###########
    end
  end
end
