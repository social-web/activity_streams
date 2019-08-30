# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  module Concerns
    RSpec.describe Serialization do
      describe '#to_json' do
        it 'deep serializes to JSON' do
          json = File.read(
            File.join(__dir__, '../../fixtures/extended_activity.json')
          )

          obj = ActivityStreams.from_json(json)
          expect(obj._original_json).to eq(json)

          original = JSON.parse(obj._original_json)
          serialized = JSON.parse(obj.to_json)

          expect(original.hash).to eq(serialized.hash)
        end
      end
    end
  end
end
