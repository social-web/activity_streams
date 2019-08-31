# frozen_string_literal: true

# require 'concurrent'
# require 'concurrent/edge/promises'
# require 'concurrent/edge/channel'
# require 'concurrent/edge/erlang_actor'
#
# class HTTPClient < Concurrent::Actor::Context
#   # override on_message to define actor's behaviour
#   def on_message(message)
#     if Integer === message
#       @count += message
#     end
#   end
# end #

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
            define_method(name) do |arg = nil|
              if arg
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

              if ActivityStreams.internet.on?
                if options[:dereference]
                  if IRI::IsResolveable.call(name, v)
                    v = IRI::Dereference.call(v)
                  end
                end
              end

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
          "The propery '#{m}' is not available on #{self}."
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
