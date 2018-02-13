
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License

require_relative '../../support/feature/comparable_as_hash'
require_relative '../../support/feature/hash_from_initialization_contract'
require_relative '../../support/types'

module TritonOps
  module Resource
    class VirtualMachine
      class NetworkInterface
        include ::Contracts::Core
        include ::Contracts::Builtin
        include ::TritonOps::Support::Feature::ComparableAsHash
        include ::TritonOps::Support::Feature::HashFromInitializationContract
        include ::TritonOps::Support::Types

        Model = ::Contracts::Enum[*%w(virtio e1000 rtl8139)]

        Contract ({
                    :interface    => String,
                    :ip           => String,
                    :ips          => ArrayOf[String],
                    :mac          => String,
                    :nic_tag      => String,
                    :gateway      => Maybe[String],
                    :gateways     => Maybe[ArrayOf[String]],
                    :model        => Maybe[Model],
                    :mtu          => Maybe[Integer],
                    :netmask      => Maybe[String],
                    :network_uuid => Maybe[String],
                    :primary      => Maybe[Bool],
                    :vlan_id      => Maybe[Integer],
                  }) => NetworkInterface
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
        def interface
          @interface ||= @options.fetch :interface
        end

        Contract None => String
        def ip
          @ip ||= @options.fetch :ip
        end

        Contract None => ArrayOf[String]
        def ips
          @ips ||= @options.fetch :ips
        end

        Contract None => String
        def mac
          @mac ||= @options.fetch :mac
        end

        Contract None => String
        def nic_tag
          @nic_tag ||= @options.fetch :nic_tag
        end

        #######################
        # Optional Properties #
        #######################

        Contract None => Maybe[String]
        def gateway
          @gateway ||= (@options || {}).fetch(:gateway, nil)
        end

        Contract None => ArrayOf[String]
        def gateways
          @gateways ||= @options.fetch(:gateways, [])
        end

        Contract None => Maybe[Model]
        def model
          @model ||= (@options || {}).fetch(:model, nil)
        end

        Contract None => Maybe[Integer]
        def mtu
          @mtu ||= (@options || {}).fetch(:mtu, nil)
        end

        Contract None => Maybe[String]
        def netmask
          @netmask ||= (@options || {}).fetch(:netmask, nil)
        end

        Contract None => Maybe[String]
        def network_uuid
          @network_uuid ||= (@options || {}).fetch(:network_uuid, nil)
        end

        Contract None => Maybe[Bool]
        def primary
          @primary ||= (@options || {}).fetch(:primary, nil)
        end

        Contract None => Maybe[Integer]
        def vlan_id
          @vlan_id ||= (@options || {}).fetch(:vlan_id, nil)
        end
      end
    end
  end
end
