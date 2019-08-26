# frozen_string_literal: true

module ActivityStreams
  class NoPropertyError < ActivityStreams::Error; end

  module Concerns
    module Properties
      def self.included(base)
        base.class_eval do
          def self.properties
            types.keys
          end

          def self.types
            @types ||= self.ancestors[1..].
                select { |anc| anc.respond_to?(:types) }.
                each.with_object({}) { |anc, t| t.merge!(anc.types) }
          end

          def self.property(name, type = ::ActivityStreams::PropertyTypes::Any)
            name = name.to_sym
            return if method_defined?(name) || singleton_methods.include?(name)

            types.merge!(name => type)

            # If called on a class, we want the property to be available on all
            # instances of the class. If called on a singleton class, we want
            # the property to be available only on the particular instance. This
            # avoids polluting objects with unnecessary context.
            def_method = self.is_a?(Class) ?
              :define_method :
              :define_singleton_method

            # Define getter
            define_method(name) { instance_variable_get("@#{name}") }

            # Define setter
            define_method("#{name}=") do |v|
              v._parent = self if v.is_a?(ActivityStreams::Model)
              properties[name] = v
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
          "The propery '#{m}' is not available on #{self.class}."
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

      def types
        self.class.types
      end

      def valid?
        properties.each { |k, v| check_type(v, types[k]) }
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
