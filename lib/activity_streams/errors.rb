# frozen_string_literal: true

module ActivityStreams
  class Error < StandardError; end
  class UnsupportedType < Error
    attr_reader :json

    def initialize(json)
      @json = json
      super(<<~MSG)
        Unable to serialize an ActivityStreams object from JSON. Please see the
        documentation on how to extend ActivityStreams with custom types.

        #{@json}
      MSG
    end
  end
end
