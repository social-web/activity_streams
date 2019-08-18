# frozen_string_literal: true

module ActivityStreams
  class Object::Event < Object
    ActivityStreams.register_type('Event', self)
  end
end
