# frozen_string_literal: true

module ActivityStreams
  class NoPropertyError < ActivityStreams::Error; end

  module Concerns
    module Properties
      def self.included(base)
        base.class_eval do
          def self.properties
            @properties ||= self.ancestors[1..].
                select { |anc| anc.respond_to?(:properties) }.
                each.with_object({}) { |anc, props| props.merge!(anc.properties) }
          end

          def self.property(name, **options)
            name = name.to_sym
            type = options[:type] || ::ActivityStreams::PropertyTypes::Any
            properties.merge!(name => type)
          end
        end
      end

      def [](prop)
        properties[prop.to_sym]
      end

      def []=(prop, val)
        properties[prop.to_sym] = val
      end

      def errors
        @errors ||= []
      end

      def properties
        @properties ||= {}
      end

      def properties=(props)
        props.each { |k, v| properties.merge!(k.to_sym => v) }
      end

      def valid?
        check_types
        errors.none?
      end

      private

      def check_types
        properties.each do |k, v|
          type = self.class.properties[k]
          type[v]
        rescue Dry::Types::ConstraintError => e
          errors << { k => e.message }
        end
      end
    end
  end
end
