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
        activity.beep = ActivityStreams::Object.new
        expect(activity.beep._parent).to eq(activity)
      end

      it 'removes the child context' do
        child = ActivityStreams::Object.new
        child.singleton_class.property :context
        child.context = 'child context'

        expect(child).to respond_to(:context)
        expect(child.instance_variables).to include(:@context)
        expect(child.context).to include('child context')

        activity.class.property :context
        activity.class.property :child
        activity.context = 'parent context'
        activity.child = child

        expect(child).not_to respond_to(:context=)
        expect(child.instance_variables).not_to include(:@context)
        expect(child.context).to eq(activity.context)
      end
    end
  end
end
