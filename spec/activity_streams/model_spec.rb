# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Model do
    it 'sets type on initialize' do
      obj = ::ActivityStreams::Object.new
      expect(obj.type).to eq('Object')
    end

    describe '#==' do
      it 'is equal to a model by id' do
        id = 'https://example.com/1'
        act1 = ActivityStreams::Object.new(id: id)
        act2 = ActivityStreams::Object.new(id: id)
        expect(act1).to eq(act2)
      end

      it 'is equal to a hash by id' do
        id = 'https://example.com/1'
        act = ActivityStreams::Object.new(id: id)
        hash1 = { id: id }
        hash2 = { 'id' => id }
        expect(act).to eq(hash1)
        expect(act).to eq(hash2)
      end
    end
  end
end
