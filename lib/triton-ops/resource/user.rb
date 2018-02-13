
# -*- ruby -*-

require 'contracts' # BSD-2-Clause License
require 'time'      # Ruby Standard Library

require_relative '../support/feature/comparable_as_hash'
require_relative '../support/feature/hash_from_initialization_contract'
require_relative '../support/types'
require_relative '../support/type_coercion'

module TritonOps
  module Resource
    class User
      include ::Contracts::Core
      include ::Contracts::Builtin
      include ::TritonOps::Support::Feature::ComparableAsHash
      include ::TritonOps::Support::Feature::HashFromInitializationContract
      include ::TritonOps::Support::Types
      include ::TritonOps::Support::TypeCoercion

      Contract ({
                  :cn                        => String,
                  :controls                  => ArrayOf[Any],
                  :created_at                => Castable::Time,
                  :dn                        => String,
                  :email                     => String,
                  :givenname                 => String,
                  :login                     => String,
                  :objectclass               => String,
                  :pwdchangedtime            => Castable::Time,
                  :pwdendtime                => Castable::Time,
                  :sn                        => String,
                  :updated_at                => Castable::Time,
                  :uuid                      => String,
                  :approved_for_provisioning => Maybe[Castable::Bool],
                  :company                   => Maybe[String],
                  :phone                     => Maybe[String],
                  :pwdhistory                => Maybe[Or[String, ArrayOf[String]]],
                  :registered_developer      => Maybe[Castable::Bool],
                  :tenant                    => Maybe[String],
                  :triton_cns_enabled        => Maybe[Castable::Bool],
                }) => User
      def initialize(**options)
        @options = options
        self.to_h
        remove_instance_variable '@options'
        self
      end

      Contract Any => Bool
      def ==(other)
        (other.respond_to?(:to_h) && (self.to_h == other.to_h)) || false
      end

      #######################
      # Required Properties #
      #######################

      Contract None => String
      def cn
        @cn ||= @options.fetch(:cn)
      end

      Contract None => ArrayOf[Any]
      def controls
        @controls ||= @options.fetch(:controls)
      end

      Contract None => Time
      def created_at
        @created_at ||= Coerce.to_time @options.fetch :created_at
      end

      Contract None => String
      def dn
        @dn ||= @options.fetch(:dn)
      end

      Contract None => String
      def email
        @email ||= @options.fetch(:email)
      end

      Contract None => String
      def givenname
        @givenname ||= @options.fetch(:givenname)
      end

      Contract None => String
      def login
        @login ||= @options.fetch(:login)
      end

      Contract None => String
      def objectclass
        @objectclass ||= @options.fetch(:objectclass)
      end

      Contract None => Time
      def pwdchangedtime
        @password_changed_time ||= Coerce.to_time @options.fetch :pwdchangedtime
      end

      Contract None => Time
      def pwdendtime
        @password_end_time ||= Coerce.to_time @options.fetch :pwdendtime
      end

      Contract None => String
      def sn
        @sn ||= @options.fetch(:sn)
      end

      Contract None => Time
      def updated_at
        @updated_at ||= Coerce.to_time @options.fetch :updated_at
      end

      Contract None => String
      def uuid
        @uuid ||= @options.fetch(:uuid)
      end

      alias common_name cn
      alias distinguished_name dn
      alias given_name givenname
      alias object_class objectclass
      alias password_changed_time pwdchangedtime
      alias password_last_changed pwdchangedtime
      alias password_end_time pwdendtime

      #######################
      # Optional Properties #
      #######################

      Contract None => Maybe[Bool]
      def approved_for_provisioning
        @approved_for_provisioning ||= case (@options || {}).fetch(:approved_for_provisioning, nil)
                                       when nil
                                         nil
                                       when 'true', true
                                         true
                                       when 'false', false
                                         false
                                       end
      end

      Contract None => Maybe[String]
      def company
        @company ||= (@options || {}).fetch(:company, nil)
      end

      Contract None => Maybe[String]
      def phone
        @phone ||= (@options || {}).fetch(:phone, nil)
      end

      Contract None => ArrayOf[String]
      def pwdhistory
        @password_history ||= case raw = @options.fetch(:pwdhistory, nil)
                              when Array
                                raw
                              when String
                                [raw]
                              when nil
                                []
                              end
      end

      Contract None => Maybe[Bool]
      def registered_developer
        @registered_developer ||= case (@options || {}).fetch(:registered_developer, nil)
                                  when nil
                                    nil
                                  when 'true', true
                                    true
                                  when 'false', false
                                    false
                                  end
      end

      Contract None => Maybe[String]
      def tenant
        @tenant ||= (@options || {}).fetch(:tenant, nil)
      end

      Contract None => Maybe[Bool]
      def triton_cns_enabled
        @triton_cns_enabled ||= case (@options || {}).fetch(:triton_cns_enabled, nil)
                                when 'true'
                                  true
                                when 'false'
                                  false
                                end
      end

      alias approved_for_provisioning? approved_for_provisioning
      alias cns_enabled triton_cns_enabled
      alias cns_enabled? triton_cns_enabled
      alias password_history pwdhistory
      alias registered_developer? registered_developer
      alias triton_cns_enabled? triton_cns_enabled
    end
  end
end
