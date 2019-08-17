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

  class Model
    include Concerns::Properties
    include Concerns::Serialization

    attr_accessor :original_json

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
