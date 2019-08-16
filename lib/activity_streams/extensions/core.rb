# frozen_string_literal: true

module ActivityStreams
  module Core
    ActivityStreams::Model.register_context(
      'https://www.w3.org/ns/activitystreams', self
    )

    def self.included(mod)
      mod.class_eval do
        attribute :'@context'
        alias_attribute :_context, :'@context'
        attribute :type, :string

        validates :type, inclusion: { in: ->(obj) { obj.class.name } }
      end
    end
  end
end
