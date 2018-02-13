
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License

require_relative '../support/feature/comparable_as_hash'
require_relative '../support/feature/hash_from_initialization_contract'
require_relative '../support/types'
require_relative '../support/type_coercion'
require_relative 'user'

module TritonOps
  module Resource
    class Image
      include ::Contracts::Core
      include ::Contracts::Builtin
      include ::TritonOps::Support::Feature::ComparableAsHash
      include ::TritonOps::Support::Feature::HashFromInitializationContract
      include ::TritonOps::Support::Types
      include ::TritonOps::Support::TypeCoercion

      Type = Enum[*%w(zone-dataset docker lx-dataset zvol other)]
      OS   = Enum[*%w(smartos linux other bsd)]
      State = Enum[*%w(active)]
      NICDriver = Enum[*%w(virtio)]
      DiskDriver = Enum[*%w(virtio)]
      CPU = Enum[*%w(host)]

      Contract ({
                  :v            => Integer,
                  :uuid         => String,
                  :owner        => String,
                  :name         => String,
                  :version      => String,
                  :state        => State,
                  :disabled     => Bool,
                  :public       => Bool,
                  :published_at => Or[String, Time],
                  :type         => Type,
                  :os           => OS,
                  :files        => ArrayOf[HashOf[Or[String, Symbol], Any]],

                  :description  => Maybe[String],
                  :requirements => Maybe[HashOf[Or[String, Symbol], Any]],
                  :tags         => Maybe[HashOf[Or[String, Symbol], Any]],
                  :homepage     => Maybe[String],
                  :origin       => Maybe[String],
                  :urn          => Maybe[String],
                  :users        => Maybe[ArrayOf[HashOf[Or[String, Symbol], Any]]],
                  :nic_driver   => Maybe[NICDriver],
                  :disk_driver  => Maybe[DiskDriver],
                  :cpu_type     => Maybe[CPU],
                  :image_size   => Maybe[Integer],
                }) => Image
      def initialize(**options)
        @options = options
        self.to_h
        remove_instance_variable '@options'
        self
      end

      #######################
      # Required Properties #
      #######################

      Contract None => Integer
      def v
        @v ||= @options.fetch :v
      end

      Contract None => String
      def uuid
        @uuid ||= @options.fetch :uuid
      end

      Contract None => String
      def owner
        @owner ||= @options.fetch :owner
      end

      Contract None => String
      def name
        @name ||= @options.fetch :owner
      end

      Contract None => String
      def version
        @version ||= @options.fetch :owner
      end

      Contract None => State
      def state
        @state ||= @options.fetch :state
      end

      Contract None => Bool
      def disabled
        @disabled ||= (@options || {}).fetch :disabled, false
      end

      Contract None => Bool
      def public
        @public ||= (@options || {}).fetch :public, false
      end

      Contract None => Time
      def published_at
        @published_at ||= Coerce.to_time @options.fetch :published_at
      end

      Contract None => Type
      def type
        @type ||= @options.fetch :type
      end

      Contract None => OS
      def os
        @os ||= @options.fetch :os
      end

      Contract None => ArrayOf[HashOf[Symbol, Any]]
      def files
        @files ||= @options.fetch(:files).map { |file| file.transform_keys(&:to_sym) }
      end

      alias disabled? disabled
      alias public? public

      ################################################
      # Optional Properties (with sensible defaults) #
      ################################################

      Contract None => HashOf[Symbol, Any]
      def requirements
        @requirements ||= @options.fetch(:requirements, {}).transform_keys(&:to_sym)
      end

      Contract None => HashOf[String, Any]
      def tags
        @tags ||= @options.fetch(:tags, {}).transform_keys(&:to_s)
      end

      Contract None => ArrayOf[HashOf[Symbol, String]]
      def users
        @users ||= @options.fetch :users, []
      end

      ##########################################
      # Optional Properties (without defaults) #
      ##########################################

      Contract None => Maybe[String]
      def description
        @description ||= (@options || {}).fetch :description, nil
      end

      Contract None => Maybe[String]
      def homepage
        @homepage ||= (@options || {}).fetch :homepage, nil
      end

      Contract None => Maybe[String]
      def origin
        @origin ||= (@options || {}).fetch :origin, nil
      end

      Contract None => Maybe[String]
      def urn
        @urn ||= (@options || {}).fetch :urn, nil
      end

      Contract None => Maybe[NICDriver]
      def nic_driver
        @nic_driver ||= (@options || {}).fetch :nic_driver, nil
      end

      Contract None => Maybe[DiskDriver]
      def disk_driver
        @disk_driver ||= (@options || {}).fetch :disk_driver, nil
      end

      Contract None => Maybe[CPU]
      def cpu_type
        @cpu_type ||= (@options || {}).fetch :cpu_type, nil
      end

      Contract None => Maybe[Integer]
      def image_size
        @image_size ||= (@options || {}).fetch :image_size, nil
      end

      alias size image_size
    end
  end
end
