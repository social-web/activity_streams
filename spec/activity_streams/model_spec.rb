# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Model do
    describe '.register_type' do
      let(:some_class) { Class.new(ActivityStreams::Model) }
      let(:type) { 'Boop' }
      after(:each) do
        ActivityStreams.types.delete type
        ActivityStreams.singleton_class.remove_method(type.downcase)
      end

      it 'stores the type and its klass' do
        expect { ActivityStreams.register_type(type, some_class) }.
          to change { ActivityStreams.types[type] }.to(some_class)
      end

      it 'defines a convenient getter method for the type' do
        expect { ActivityStreams.register_type(type, some_class) }.
          to change { ActivityStreams.respond_to?(type.downcase) }.to(true)
        expect(ActivityStreams.public_send(type.downcase)).
          to be_an_instance_of(some_class)
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
