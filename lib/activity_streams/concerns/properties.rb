# frozen_string_literal: true

module ActivityStreams
  class NoPropertyError < ActivityStreams::Error; end

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

      def method_missing(m, *args, &block)
        raise NoPropertyError,
          "The propery '#{m}' is not available on #{self.class}. " \
            "ActivityStream objects can be extended to support additional "
            "properties."
      end

      def properties
        @properties ||= {}
      end

      def properties=(props)
        props.each do |k, v|
          setter = "#{k}="

          # Don't stop processing if we don't recognize the attr
          # https://www.w3.org/TR/2017/REC-activitystreams-core-20170523/#extensibility
          next unless respond_to?(setter)

          public_send(setter, v)
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
