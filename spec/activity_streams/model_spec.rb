# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Model do
    it 'sets type on initialize' do
      obj = ::ActivityStreams::Object.new
      expect(obj.type).to eq('Object')
    end
  end
end
