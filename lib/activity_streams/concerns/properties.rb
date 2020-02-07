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

      # Traverse this object's properties, breadth-first to the given `depth`.
      # A block will be yieled a hash of the `parent`, `child`, and `property`
      # to visit each relationship. The block must return a dereferenced child.
      def traverse_properties(props = properties.keys, depth: Float::INFINITY)
        ActivityStreams::Utilities::Queue.new.call(self, depth: depth) do |obj|
          props.each do |prop|
            queued_up = []
            next unless obj.is_a?(ActivityStreams)

            child = obj[prop]

            if block_given?
              child = yield(parent: obj, child: child, property: prop)
            end

            child
          end
        end

        self
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
