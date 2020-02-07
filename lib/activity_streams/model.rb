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
    define_singleton_method method_name do |**props, &blk|
      if blk
        instance = klass.new
        instance.instance_exec(&blk)
        instance
      else
        klass.new(props)
      end
    end

    klass
  end

  class Model
    include Concerns::Identity
    include Concerns::Properties
    include Concerns::Serialization

    attr_accessor :_original_json
    attr_accessor :_parent

    def initialize(**props)
      self.context = 'https://www.w3.org/ns/activitystreams'
      @properties = props if props
      unless @properties[:type]
        @properties[:type] = ActivityStreams.types.invert[self.class]
      end
    end

    def compress!
      traverse_properties(depth: 1) do |hash|
        parent, child, prop = hash.values_at(:parent, :child, :property)
        parent[prop] = child[:id] if child.is_a?(ActivityStreams::Object)
      end
      self
    end

    def context(arg = nil)
      if arg
        @context = arg
      else
        _parent&.context || @context
      end
    end

    def context=(ctx)
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
          new_ctx.each { |ctx| _load_extension(ctx) }
          new_ctx.one? ? new_ctx.first : new_ctx
        else
          _load_extension(ctx)
          new_ctx
        end
      end
    end

    def _parent=(v)
      self.instance_eval('undef :context=') if respond_to?(:context=)
      remove_instance_variable(:@context) if @context
      _unsupported_properties.delete('@context')
      @_parent = v
    end

    def _load_extension(ctx)
      mod = ActivityStreams.contexts[ctx]
      self.singleton_class.extend(mod) if mod
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
require_relative './objects/object'
require_relative './objects/activity'
require_relative './objects/actor'
require_relative './objects/collection'
require_relative './objects/link'
