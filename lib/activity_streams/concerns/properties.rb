# frozen_string_literal: true

module ActivityStreams
  class NoPropertyError < ActivityStreams::Error; end

  module Concerns
    module Properties
      DEFAULT_PROPERTIES = { id: nil, type: nil }.freeze
      REQUIRED_PROPERTIES = %i[id type].freeze

      def self.included(base)
        base.class_eval do
          if ActivityStreams.config.accessor_methods == true
            define_method(:method_missing) { raise NoPropertyError, "The propery '#{m}' is not available on #{self}." }
          end

          def self.properties
            @properties ||= begin
              ancestor_props = self.ancestors[1..].
                select { |anc| anc.respond_to?(:properties) }.
                each.with_object({}) { |anc, props| props.merge!(anc.properties) }.freeze

              DEFAULT_PROPERTIES.merge(ancestor_props)
            end
          end

          def self.property(name, **options)
            name = name.to_sym
            type = options[:type] || ::ActivityStreams::PropertyTypes::Any
            define_method_accessors(name) if ActivityStreams.config.accessor_methods == true
            properties.merge!(name => type)
          end

          def self.define_method_accessors(name, type = ::ActivityStreams::PropertyTypes::Any, options = {})
            # Define getter.
            define_method(name) { properties[name.to_sym] }

            # Define setter
            define_method("#{name}=") do |arg|
              # First set the current object as the parent of the value.
              # TODO: Why?
              case arg
              when ActivityStreams::Model then arg._parent = self
              when Array
                arg = arg.map { |child|
                  if child.is_a?(ActivityStreams::Model)
                    child._parent = self
                  end
                  child
                }
              end

              # Set property
              properties[name] = arg

              # Set instance var for object orientation's sake
              instance_variable_set("@#{name}", type[arg])

              arg
            end
          end
        end
      end

      def [](prop)
        properties[prop.to_sym]
      end

      def []=(prop, val)
        return unless self.class.properties.key?(prop.to_sym)

        case val
        when ActivityStreams then val._parent = self
        when Array
          val = val.map { |child|
            child._parent = self if child.is_a?(ActivityStreams)
            child
          }
        end

        properties[prop.to_sym] = val
      end

      def errors
        @errors ||= []
      end

      def merge_properties(props)
        props.each { |k, v| self[k] = v }
      end

      def properties
        @properties ||= {}
      end

      # Replace properties
      def properties=(props)
        properties.clear
        props.each { |k, v| self[k] = v }
      end

      # Traverse this object's properties, breadth-first to the given `depth`.
      # A block will be yieled a hash of the `parent`, `child`, and `property`
      # to visit each relationship. The block must return a dereferenced child.
      def traverse_properties(props = self.class.properties.keys, depth: Float::INFINITY)
        ActivityStreams::Utilities::Queue.new.call(self, depth: depth) do |obj|
          next unless obj.is_a?(ActivityStreams)

          props.each do |prop|
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
          next
        end
      end
    end
  end
end
