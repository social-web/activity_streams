# frozen_string_literal: true

module ActivityStreams
  class Collection::CollectionPage < Collection
    %w[next partOf prev].each(&method(:property))
  end
end
