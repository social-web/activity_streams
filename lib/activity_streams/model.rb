# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'validators', '*.rb')].each { |f| require f }

module ActivityStreams
  class Model
    include ActiveModel::Model
    include ActiveModel::Attributes
    include Concerns::Serialization

    CONTEXT = 'https://www.w3.org/ns/activitystreams'

    attr_accessor :original_json

    attribute :'@context'
    alias_attribute :_context, :'@context'
    attribute :type, :string

    validate Validators::ContextValidator
    validates :type, inclusion: { in: ->(obj) { obj.class.name } }

    def self.context(context)
      @contexts ||= []
      @contexts << context
    end
  end
end

Dir[File.join(__dir__, 'extensions', '**', '*.rb')].each { |f| require f }
require_relative './model/object'
require_relative './model/activity'
require_relative './model/actor'
require_relative './model/collection'
require_relative './model/link'
