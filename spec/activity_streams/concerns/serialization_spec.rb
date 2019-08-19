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
          expect(obj.original_json).to eq(json)

          expect(JSON.parse(obj.original_json).hash).
            to eq(JSON.parse(obj.to_json).hash)
        end
      end
    end
  end
end
