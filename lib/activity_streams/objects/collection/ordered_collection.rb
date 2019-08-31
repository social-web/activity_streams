# frozen_string_literal: true

module ActivityStreams
  class Collection::OrderedCollection < Collection
    ActivityStreams.register_type('OrderedCollection', self)
  end
end
