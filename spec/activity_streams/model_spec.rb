# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Model do
    describe '.register_type' do
      let(:some_class) { Class.new(ActivityStreams::Model) }
      let(:type) { 'Boop' }
      after(:each) do
        ActivityStreams.types_registry.delete type
      end

      it 'stores the type and its klass' do
        expect { ActivityStreams.register_type(type, some_class) }.
          to change { ActivityStreams.types_registry[type] }.to(some_class)
      end
    end

    describe '#initialize' do
      it 'sets properties' do
        expect(ActivityStreams::Object.new(name: 'name')[:name]).to eq('name')
      end
    end

    describe '#is_a?' do
      it 'compares types' do
        follow = ActivityStreams.from_hash(type: 'Follow')
        create_klass = ActivityStreams::Activity::Create

        expect(follow.class).not_to eq(create_klass)
        expect(follow.is_a?(create_klass)).to eq(false)

        expect(follow.is_a?(ActivityStreams::Activity::Follow)).to eq(true)
      end
    end

    describe '#==' do
      it 'is equal to a model by id' do
        id = 'https://example.com/1'
        act1 = ActivityStreams.from_hash(type: 'Follow', id: id)
        act2 = ActivityStreams.from_hash(type: 'Follow', id: id)
        expect(act1).to eq(act2)
      end

      it 'is not equal for the same object type but different ids' do
        act1 = ActivityStreams.from_hash(type: 'Create', id: 1)
        act2 = ActivityStreams.from_hash(type: 'Create', id: 2)
        expect(act1).not_to eq(act2)
      end
    end

    describe '#initialize_copy' do
      it 'produces object equal in size to the original' do
        require 'objspace'

        act = ActivityStreams.from_hash(
          type: 'Follow',
          id: 'https://example.org/beep/boop',
          replies: ActivityStreams.from_hash(type: 'Collection', items: [1, '', { type: 'Follow' }])
        )
        dupped_act = act.dup

        expect(act.object_id).not_to eq(dupped_act.object_id)
        expect(ObjectSpace.memsize_of(act)).
          to eq(ObjectSpace.memsize_of(dupped_act))
      end
    end
  end
end
