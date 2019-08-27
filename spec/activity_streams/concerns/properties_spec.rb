# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  module Concerns
    RSpec.describe Properties do
      let(:activity) {
        klass = Class.new
        klass.include described_class
        klass.new
      }

      it 'does not stop processing if attr is not recognized' do
        expect(activity).not_to respond_to(:beep=)
        expect { activity.properties = { beep: 'boop' } }.not_to raise_error
        expect { activity.beep }.to raise_error(ActivityStreams::NoPropertyError)
      end

      it 'sets the parent' do
        activity.class.property :beep
        activity.beep = ActivityStreams::Model.new
        expect(activity.beep._parent).to eq(activity)
      end

      it 'removes the child context' do
        child = ActivityStreams::Model.new
        child.singleton_class.property :_context
        child._context = 'child context'

        expect(child).to respond_to(:_context=)
        expect(child.instance_variables).to include(:@context)
        expect(child._context).to eq('child context')

        activity.class.property :_context
        activity.class.property :child
        activity._context = 'parent context'
        activity.child = child

        expect(child).not_to respond_to(:_context=)
        expect(child.instance_variables).not_to include(:@context)
        expect(child._context).to eq(activity._context)
      end
    end
  end
end
