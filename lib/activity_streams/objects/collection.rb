# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Collection < ActivityStreams::Object
    ActivityStreams.register_type('Collection', self)
    %i[current first items last totalItems].each(&method(:property))

    def is_a?(klass)
      if klass == ActivityStreams::Collection
        self.class.ancestors.include?(klass)
      else
        super
      end
    end

    def traverse_items(depth: Float::INFINITY)
      items = []
      visited_collections = Set.new

      ActivityStreams::Utilities::Queue.new.call(self, depth: depth) do |collection|
        break if visited_collections.include?(collection)

        queued_up = []

        collection = yield(collection) if block_given?

        visited_collections << collection[:id]

        case collection[:type]
        when 'Collection', 'OrderedCollection'
          if first = collection[:first]
            queued_up << first
          end
        when 'CollectionPage', 'OrderedCollectionPage'
          if nxt = collection[:next]
            queued_up << nxt
          end
        end

        items += Array(collection[:items])

        queued_up
      end

      items
    end
  end
end

Dir[File.join(__dir__, 'collection', '*.rb')].each { |f| require f }
