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

    method_name = type.to_s.gsub(/([A-Za-z\d]+)([A-Z][a-z])/,'\1_\2').downcase
    define_singleton_method method_name do |x = nil|
      klass.new(x)
    end

    klass
  end

  class Model
    include Concerns::Properties
    include Concerns::Serialization

    attr_accessor :_original_json
    attr_accessor :_parent

    def initialize(arg = nil)
      self._context = 'https://www.w3.org/ns/activitystreams'
      self.type = ActivityStreams.types.invert[self.class]

      case arg
      when Hash
        self.id = arg.delete('id') || arg.delete(:id)
        props = arg
      when String
        if arg.match?(::URI.regexp(%w[http https]))
          props = IRI::Dereference.call(arg).to_h
        else
          raise TypeError, 'Expected a hash of attributes or a URI'
        end
      end

      props.each { |k, v| public_send("#{k}=", v) } if props
    end

    def ==(obj)
      case obj
      when ActivityStreams::Model then obj.id == id
      when Hash then [obj['id'], obj[:id]].include?(id)
      else false
      end
    end

    def _context(arg = nil)
      if arg
        @context = arg
      else
        _parent&._context || @context
      end
    end

    def _context=(ctx)
      unless _parent
        new_ctx = case @context
        when NilClass then @context = ctx
        when Array
          case ctx
          when Array then @context | ctx
          when String then Array.new(@context) << ctx
          end
        when String
          case ctx
          when Array then ctx << @context
          when String then [@context, ctx]
          end
        end

        @context = case new_ctx
        when Array
          new_ctx.uniq!
          new_ctx.compact!
          new_ctx.one? ? new_ctx.first : new_ctx
        else new_ctx
        end
      end
    end

    def _parent=(v)
      self.instance_eval('undef :_context=') if respond_to?(:_context=)
      remove_instance_variable(:@context) if @context
      _unsupported_properties.delete('@context')
      @_parent = v
    end

    def id(arg = nil)
      arg ? @id = arg : @id
    end

    def id=(v)
      @id ||= v.freeze
    end

    def is_a?(klass)
      their_type = ActivityStreams.types.invert[klass]
      type == their_type
    end

    def load_extension(ext)
      self.singleton_class.extend(ext)
    end

    def type(arg = nil)
      arg ? @type = arg : @type
    end

    def type=(v)
      @type = v.freeze
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
