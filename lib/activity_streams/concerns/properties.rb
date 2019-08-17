# frozen_string_literal: true

module ActivityStreams
  module Concerns
    module Properties
      def self.included(base)
        base.class_eval do
          def self.properties
            @properties ||= {}
          end

          def self.property(name, type = ::ActivityStreams::Types::Any)
            if method_defined?(name) || singleton_methods.include?(name.to_sym)
              warn "Method \"#{name}\" already defined on #{self.class.name}. Called by #{caller[0]}"
              return
            end

            def_method = self.is_a?(Class) ? :define_method : :define_singleton_method
            define_method(name) { instance_variable_get("@#{name}") }
            define_method("#{name}=") do |v|
              instance_variable_set("@#{name}", type[v])
            rescue Dry::Types::ConstraintError => e
              errors << e.message
            end
          end
        end
      end

      def errors
        @errors ||= []
      end

      def properties
        @properties ||= {}
      end

      def properties=(props)
        props.each do |k, v|
          public_send("#{k}=", v)
          properties.merge!(k.to_sym => v)
        end
      end

      def valid?
        errors.none?
      end

      private

      def check_type(v, type)
        type[v]
      rescue Dry::Types::ConstraintError => e
        errors << e.message
      end
    end
  end
end
