# frozen_string_literal: true

require 'active_model'
require 'json'

require 'activity_streams/model'
require 'activity_streams/factory'

module ActivityStreams
  class Error < StandardError; end
  class UnsupportedType < Error; end

  class << self
    def from_json(json)
      Factory.new(json).build
    end
  end
end
