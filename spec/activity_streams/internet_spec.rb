# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Internet do
    after(:each) { internet.off }
    let(:internet) { described_class.instance }

    describe '#off' do
      it 'turns the internet on' do
        internet.on
        expect { internet.off }.
          to change { internet.on? }.from(true).to(false).
            and change { internet.off? }.from(false).to(true)
      end

      it 'turns on after block is run' do
        internet.on
        expect(internet.on?).to eq(true)
        expect {
          internet.off do
            expect(internet.off?).to eq(true)
          end
        }.not_to change { internet.on? }
      end
    end

    describe '#on' do
      it 'turns the internet on' do
        expect { internet.on }.
          to change { internet.off? }.from(true).to(false).
            and change { internet.on? }.from(false).to(true)
      end

      it 'turns off after block is run' do
        internet.off
        expect(internet.off?).to eq(true)
        expect {
          internet.on do
            expect(internet.on?).to eq(true)
          end
        }.not_to change { internet.off? }
      end
    end
  end
end
