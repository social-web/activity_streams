# frozen_string_literal: true


Dir[File.join(__dir__, 'concerns', '*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'validators', '*.rb')].each { |f| require f }

module ActivityStreams
  def self.contexts
    @contexts ||= {}
  end

  def self.register_context(ctx, mod)
    contexts[ctx] = mod
  end

  def self.types
    @types ||= {}
  end

  def self.register_type(type, klass)
    types[type.to_s] = klass
  end

  class Model
    require 'activity_streams/core'

    include Concerns::Properties
    include Concerns::Serialization
    extend ActivityStreams::Core

    attr_accessor :_original_json
    attr_accessor :_parent

    def initialize(*a)
      self._context = 'https://www.w3.org/ns/activitystreams'
      self.type = ActivityStreams.types.invert[self.class]
      case a
      when Hash then a.each { |k, v| public_send("#{k}=", v) }
      when String
        if a.match?(::URI.regexp(%w[http https]))
          IRI::Dereference.call(a)
        end
      end
    end

    def ==(obj)
      case obj
      when ActivityStreams::Model then obj.id == id
      when Hash then [obj['id'], obj[:id]].include?(id)
      else false
      end
    end

    def _context
      _parent&._context || @context
    end

    def _context=(ctx)
      properties[:_context] = @context = ctx unless _parent
    end

    def _parent=(v)
      self.instance_eval('undef :_context=') if respond_to?(:_context=)
      remove_instance_variable(:@context) if @context
      properties.delete(:_context)
      _unsupported_properties.delete('@context')
      @_parent = v
    end

    def load_extension(ext)
      self.singleton_class.extend(ext)
    end
  end
end

Dir[File.join(__dir__, 'extensions', '**', '*.rb')].each { |f| require f }
require_relative './model/object'
require_relative './model/activity'
require_relative './model/actor'
require_relative './model/collection'
require_relative './model/link'
require_relative './model/iri'
