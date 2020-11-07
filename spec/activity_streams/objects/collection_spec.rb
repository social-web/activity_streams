# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  module Objects
    RSpec.describe Collection do
      describe '#traverse_pages' do
        it 'returns an array of nested items' do
          item1 = ActivityStreams.generate_random
          item2 = ActivityStreams.generate_random
          item3 = ActivityStreams.generate_random
          item4 = ActivityStreams.generate_random

          collection = ActivityStreams.generate_random(type: 'Collection')
          collection[:items] = [item1, item2]

          first_collection = ActivityStreams.generate_random(type: 'CollectionPage')
          first_collection[:items] = [item3]

          next_collection = ActivityStreams.generate_random(type: 'Collection', next: nil, first: nil)
          next_collection[:items] = [item4]
          first_collection[:next] = next_collection

          collection[:first] = first_collection

          expect(collection.traverse_pages).to eq([item1, item2, item3, item4])
        end

        it 'visits each nested collection' do
          collection = ActivityStreams.generate_random(type: 'Collection')
          first_collection = ActivityStreams.generate_random(type: 'CollectionPage')
          next_collection = ActivityStreams.generate_random(type: 'Collection', next: nil, first: nil)

          first_collection[:next] = next_collection
          collection[:first] = first_collection

          collections = [collection, first_collection, next_collection]

          expect { |probe|
            i = 0
            collection.traverse_pages do |collection|
              probe.to_proc.call(collection)
              col = collections[i]
              i += 1
              col
            end
          }.to yield_successive_args(*collections)
        end
      end
    end
  end
end
