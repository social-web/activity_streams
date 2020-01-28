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
                each.with_object({}) { |anc, t| t.merge!(anc.properties) }
          end

          def self.property(name, type = ::ActivityStreams::PropertyTypes::Any, options = {})
            options = { dereference: false }.merge(options)
            name = name.to_sym
            return if method_defined?(name) || singleton_methods.include?(name)

            properties.merge!(name => type)

            # Define getter
            define_method(name) do |arg = nil, &blk|
              if blk
                public_send("#{name}=", blk.call)
              elsif arg
                public_send("#{name}=", arg)
              else
                instance_variable_get("@#{name}")
              end
            end

            # Define setter
            define_method("#{name}=") do |v|
              case v
              when ActivityStreams::Model then v._parent = self
              when Array
                v = v.map { |child|
                  if child.is_a?(ActivityStreams::Model)
                    child._parent = self
                  end
                  child
                }
              end

              properties[name] = v
              instance_variable_set("@#{name}", type[v])
            rescue Dry::Types::ConstraintError => e
              errors << e.message
            end
          end
        end
      end

      def [](prop)
        @properties[prop]
      end

      def []=(prop, val)
        @properties[prop] = val
      end

      def errors
        @errors ||= []
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
