# frozen_string_literal: true

require 'activity_streams/objects/collection/ordered_collection'

module ActivityStreams
  class Collection::OrderedCollectionPage < Collection::OrderedCollection
    ActivityStreams.register_type('OrderedCollectionPage', self)
    %i[next partOf prev].each(&method(:property))
  end
end
