# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Model do
    describe '.register_type' do
      it 'stores the type and its klass' do
        type = 'Boop'
        SomeClass = Class.new
        expect { ActivityStreams.register_type(type, SomeClass) }.
          to change { ActivityStreams.types[type] }.to(SomeClass)
        ActivityStreams.types.delete type
        ActivityStreams.singleton_class.remove_method(type.downcase)
      end

      it 'defines a convenient getter method for the type' do
        type = 'Boop'
        AnotherClass = Class.new
        expect { ActivityStreams.register_type(type, SomeClass) }.
          to change { ActivityStreams.respond_to?(type.downcase) }.to(true)
        expect(
          ActivityStreams.public_send(type.downcase)
        ).to be_an_instance_of(SomeClass)
        ActivityStreams.types.delete type
        ActivityStreams.singleton_class.remove_method(type.downcase)
      end
    end

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

    describe '#is_a?' do
      it 'compares types' do
        follow = ActivityStreams::Object.new(type: 'Follow')
        create_klass = ActivityStreams::Activity::Create

        expect(follow.class).not_to eq(create_klass)
        expect(follow.is_a?(create_klass)).to eq(false)

        expect(follow.is_a?(ActivityStreams::Activity::Follow)).to eq(true)
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
