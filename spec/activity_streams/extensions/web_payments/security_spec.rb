# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  module Extensions
    module WebPayments
      RSpec.describe Security do
        let(:activity) {
          act = Class.new(ActivityStreams::Object)
          act.extend described_class
          act.new
        }

        it 'includes relevant properties' do
          %i[id owner publicKey publicKeyPem].each do |prop|
            expect(activity).to respond_to(prop)
            expect(activity).to respond_to("#{prop}=")
          end
        end
      end
    end
  end
end
