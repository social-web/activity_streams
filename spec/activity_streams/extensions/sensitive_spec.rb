# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  module Extensions
    RSpec.describe Sensitive do
      it 'loads the context' do
        allow(ActivityStreams).
          to receive(:contexts).
          and_return('as:sensitive' => described_class)
        act = ActivityStreams::Object.new
        expect(act).not_to respond_to(:sensitive)
        expect(act).not_to respond_to(:sensitive=)
        act._load_extension('as:sensitive')
        expect(act).to respond_to(:sensitive)
        expect(act).to respond_to(:sensitive=)

        expect(act.sensitive).to eq(nil)
        act.sensitive = false
        expect(act.sensitive).to eq(false)
        act.sensitive = true
        expect(act.sensitive).to eq(true)
      end
    end
  end
end
