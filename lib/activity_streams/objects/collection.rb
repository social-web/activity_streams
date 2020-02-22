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

        collection = yield(collection) if block_given?

        visited_collections << collection[:id]

        case collection[:type]
        when 'Collection', 'OrderedCollection'
          queue << first if first = collection[:first]
        when 'CollectionPage', 'OrderedCollectionPage'
          queue << nxt if nxt = collection[:next]
        end

        items += Array(collection[:items])
      end

      items
    end
  end
end

Dir[File.join(__dir__, 'collection', '*.rb')].each { |f| require f }
