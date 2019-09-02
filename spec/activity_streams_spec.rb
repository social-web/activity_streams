# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::ActivityStreams do
  describe 'ActivityStreams()' do
    it 'builds an object' do
      act = ActivityStreams.new { type 'Follow' }
      expect(act.context).to eq(ActivityStreams::NAMESPACE)
      expect(act.type).to eq('Follow')
    end
  end

  describe '#from_json' do
    it 'delegates to factory' do
      json = '{}'
      factory = instance_double('ActivityStreams::Factory', build: nil)

      expect(ActivityStreams::Factory).
        to receive(:new).
        with(json).
        and_return(factory)

      described_class.from_json(json)
    end
  end
end
