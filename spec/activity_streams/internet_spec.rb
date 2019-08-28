# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Internet do
    describe '#off' do
      it 'turns the internet on' do
        internet = described_class.instance
        internet.on
        expect { internet.off }.
          to change { internet.on? }.from(true).to(false).
            and change { internet.off? }.from(false).to(true)
      end
    end

    describe '#on' do
      it 'turns the internet on' do
        internet = described_class.instance
        expect { internet.on }.
          to change { internet.off? }.from(true).to(false).
            and change { internet.on? }.from(false).to(true)
      end
    end
  end
end
