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
    end
  end
end
