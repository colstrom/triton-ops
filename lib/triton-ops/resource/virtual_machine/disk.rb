
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License

require_relative '../../support/feature/comparable_as_hash'
require_relative '../../support/feature/hash_from_initialization_contract'
require_relative '../../support/types'

module TritonOps
  module Resource
    class VirtualMachine
      class Disk
        include ::Contracts::Core
        include ::Contracts::Builtin
        include ::TritonOps::Support::Feature::ComparableAsHash
        include ::TritonOps::Support::Feature::HashFromInitializationContract
        include ::TritonOps::Support::Types

        Media = ::Contracts::Enum[*%w(disk cdrom)]
        Model = ::Contracts::Enum[*%w(virtio ide scsi)]

        Contract ({
                    :block_size     => Integer,
                    :compression    => CompressionAlgorithm,
                    :media          => Media,
                    :model          => Model,
                    :path           => String,
                    :refreservation => Integer,
                    :size           => Integer,
                    :zfs_filesystem => String,
                    :zpool          => String,
                    :boot           => Maybe[Bool],
                    :image_size     => Maybe[Integer],
                    :image_uuid     => Maybe[String],
                  }) => Disk
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
        def block_size
          @block_size ||= @options.fetch :block_size
        end

        Contract None => CompressionAlgorithm
        def compression
          @compression ||= @options.fetch :compression
        end

        Contract None => Media
        def media
          @media ||= @options.fetch :media
        end

        Contract None => Model
        def model
          @model ||= @options.fetch :model
        end

        Contract None => String
        def path
          @path ||= @options.fetch :path
        end

        Contract None => Integer
        def refreservation
          @refreservation ||= @options.fetch :refreservation
        end

        Contract None => Integer
        def size
          @size ||= @options.fetch :size
        end

        Contract None => String
        def zfs_filesystem
          @zfs_filesystem ||= @options.fetch :zfs_filesystem
        end

        Contract None => String
        def zpool
          @zpool ||= @options.fetch :zpool
        end

        #######################
        # Optional Properties #
        #######################

        Contract None => Maybe[Bool]
        def boot
          @boot ||= (@options || {}).fetch(:boot, nil)
        end

        Contract None => Maybe[Integer]
        def image_size
          @image_size ||= (@options || {}).fetch(:image_size, nil)
        end

        Contract None => Maybe[String]
        def image_uuid
          @image_uuid ||= (@options || {}).fetch(:image_uuid, nil)
        end

        #######################
        # Convenience Methods #
        #######################

        Contract None => Bool
        def image?
          image_uuid ? true : false
        end
      end
    end
  end
end
