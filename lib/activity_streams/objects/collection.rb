# frozen_string_literal: true

require_relative 'object'

module ActivityStreams
  class Collection < ActivityStreams::Object
    ActivityStreams.register_type('Collection', self)
    %i[current first items last totalItems].each(&method(:property))

    def traverse_items(depth: SocialWeb['config'].max_depth)
      loop_count = 0
      queue = self[:items] || []
      items = []
      visited_collections = Set.new

      while !queue.empty? && loop_count <= 20
        collection = queue.shift
        break if visited_collections.include?(collection)

        collection = yield(collection) if block_given?

        visited_collections << collection[:id]

        case collection[:type]
        when 'Collection', 'OrderedCollection'
          if first = collection[:first]
            queue << first
          end
        when 'CollectionPage', 'OrderedCollectionPage'
          if nxt = collection[:next]
            queue << nxt
          end
        end

        items += Array(collection[:items])
      end

      items
    end
  end
end

Dir[File.join(__dir__, 'collection', '*.rb')].each { |f| require f }
