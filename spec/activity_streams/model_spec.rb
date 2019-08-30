# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Model do
    describe '#initialize' do
      it 'sets type on initialize' do
        obj = ::ActivityStreams::Object.new
        expect(obj.type).to eq('Object')
      end

      context 'arg is a Hash' do
        it 'treats hash as attributes to set' do
          expect(ActivityStreams::Object.new(name: '').name).to eq('')
        end
      end

      context 'arg is a String' do
        it 'treats a url as a dereferencable object' do
          iri = 'https://example.com'
          expect(IRI::Dereference).to receive(:call).with(iri)
          ActivityStreams::Object.new(iri)
        end

        it 'raises an error if not a URI' do
          iri = 'not a URI'
          expect { ActivityStreams::Object.new(iri) }.to raise_error(TypeError)
        end
      end
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
