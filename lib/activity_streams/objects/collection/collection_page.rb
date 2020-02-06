# frozen_string_literal: true

module ActivityStreams
  class Collection::CollectionPage < Collection
    ActivityStreams.register_type('CollectionPage', self)
    %i[next partOf prev].each(&method(:property))
  end
end
