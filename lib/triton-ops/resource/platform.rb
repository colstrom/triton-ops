
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'time'      # Ruby Standard Library

require_relative '../support/feature/comparable_as_hash'
require_relative '../support/feature/hash_from_initialization_contract'
require_relative '../support/type_coercion'
require_relative '../support/types'

module TritonOps
  module Resource
    class Platform
      include ::Contracts::Core
      include ::Contracts::Builtin
      include ::TritonOps::Support::Feature::ComparableAsHash
      include ::TritonOps::Support::Feature::HashFromInitializationContract
      include ::TritonOps::Support::TypeCoercion
      include ::TritonOps::Support::Types

      ServerReference = {
        hostname: String,
        uuid:     String,
      }

      Contract ({
                  :boot_platform => ArrayOf[ServerReference],
                  :current_platform => ArrayOf[ServerReference],
                  :default => Bool,
                  :latest => Bool,
                  :usb_key => Bool,
                  :version => Castable::Time,
                }) => Platform
      def initialize(**options)
        @options = options
        self.to_h
        remove_instance_variable '@options'
        self
      end

      #######################
      # Required Properties #
      #######################

      Contract None => Time
      def version
        @version ||= Coerce.to_time @options.fetch :version
      end

      Contract None => ArrayOf[ServerReference]
      def boot_platform
        @boot_platform ||= @options.fetch(:boot_platform).map { |hash| hash.transform_keys(&:to_sym) }
      end

      Contract None => ArrayOf[ServerReference]
      def current_platform
        @current_platform ||= @options.fetch(:current_platform).map { |hash| hash.transform_keys(&:to_sym) }
      end

      Contract None => Bool
      def latest
        @latest ||= (@options || {}).fetch(:latest, false)
      end

      Contract None => Bool
      def default
        @default ||= (@options || {}).fetch(:default, false)
      end

      Contract None => Bool
      def usb_key
        @usb_key ||= (@options || {}).fetch(:usb_key, false)
      end

      alias latest? latest
      alias default? default
      alias usb_key? usb_key
    end
  end
end
