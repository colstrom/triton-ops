
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License

require_relative '../support/feature/comparable_as_hash'
require_relative '../support/feature/hash_from_initialization_contract'
require_relative '../support/types'
require_relative '../support/type_coercion'
require_relative 'user'

module TritonOps
  module Resource
    class Server
      include ::Contracts::Core
      include ::Contracts::Builtin
      include ::TritonOps::Support::Feature::ComparableAsHash
      include ::TritonOps::Support::Feature::HashFromInitializationContract
      include ::TritonOps::Support::Types
      include ::TritonOps::Support::TypeCoercion

      Status             = Enum[*%(running)]
      TransitionalStatus = Enum[""]
      Console            = Enum[*%w(serial)]
      SerialInterface    = Enum[*%w(ttya ttyb vga)]

      Contract ({
                  :boot_params          => HashOf[Or[String, Symbol], Any],
                  :boot_platform        => String,
                  :comments             => String,
                  :created              => Castable::Time,
                  :current_platform     => String,
                  :datacenter           => String,
                  :headnode             => Bool,
                  :kernel_flags         => HashOf[Or[String, Symbol], Any],
                  :last_boot            => Castable::Time,
                  :overprovision_ratio  => Num,
                  :rack_identifier      => String,
                  :ram                  => Integer,
                  :reservation_ratio    => Num,
                  :reserved             => Bool,
                  :reservoir            => Bool,
                  :setup                => Bool,
                  :status               => Status,
                  :traits               => HashOf[Or[String, Symbol], Any],
                  :transitional_status  => TransitionalStatus,
                  :uuid                 => String,

                  :boot_modules         => Maybe[ArrayOf[Any]],
                  :default_console      => Maybe[Console],
                  :serial               => Maybe[SerialInterface],
                }) => Server
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
      def datacenter
        @datacenter ||= @options.fetch :datacenter
      end

      Contract None => Num
      def overprovision_ratio
        @overprovision_ratio ||= @options.fetch :overprovision_ratio
      end

      Contract None => Num
      def reservation_ratio
        @reservation_ratio ||= @options.fetch :reservation_ratio
      end

      Contract None => Bool
      def reservoir
        @reservoir ||= (@options || {}).fetch :reservoir, false
      end

      Contract None => HashOf[Symbol, Any]
      def traits
        @traits ||= @options.fetch(:traits).transform_keys(&:to_sym)
      end

      Contract None => String
      def rack_identifier
        @rack_identifier ||= @options.fetch :rack_identifier
      end

      Contract None => String
      def comments
        @comments ||= @options.fetch :comments
      end

      Contract None => String
      def uuid
        @uuid ||= @options.fetch :uuid
      end

      Contract None => Bool
      def reserved
        @reserved ||= (@options || {}).fetch :reserved, false
      end

      Contract None => String
      def boot_platform
        @boot_platform ||= @options.fetch :boot_platform
      end

      Contract None => HashOf[Symbol, Any]
      def boot_params
        @boot_params ||= @options.fetch(:boot_params).transform_keys(&:to_sym)
      end

      Contract None => HashOf[Symbol, Any]
      def kernel_flags
        @kernel_flags ||= @options.fetch(:kernel_flags).transform_keys(&:to_sym)
      end

      Contract None => Integer
      def ram
        @ram ||= @options.fetch :ram
      end

      Contract None => Status
      def status
        @status ||= @options.fetch :status
      end

      Contract None => Bool
      def headnode
        @headnode ||= (@options || {}).fetch :headnode, false
      end

      Contract None => String
      def current_platform
        @current_platform ||= @options.fetch :current_platform
      end

      Contract None => Bool
      def setup
        @setup ||= (@options || {}).fetch :setup, false
      end

      Contract None => Time
      def last_boot
        @last_boot ||= Coerce.to_time @options.fetch :last_boot
      end

      Contract None => Time
      def created
        @created ||= Coerce.to_time @options.fetch :created
      end

      Contract None => TransitionalStatus
      def transitional_status
        @transitional_status ||= @options.fetch :transitional_status
      end

      alias headnode? headnode
      alias reserved? reserved
      alias setup? setup

      #######################
      # Optional Properties #
      #######################

      Contract None => Maybe[ArrayOf[Any]]
      def boot_modules
        @boot_modules ||= (@options || {}).fetch :boot_modules, nil
      end

      Contract None => Maybe[String]
      def default_console
        @default_console ||= (@options || {}).fetch :default_console, nil
      end

      Contract None => Maybe[String]
      def serial
        @serial ||= (@options || {}).fetch :serial, nil
      end
    end
  end
end
