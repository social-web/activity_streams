# frozen_string_literal: true

module ActivityStreams
  class Object::Note < Object
    ActivityStreams.register_type('Note', self)
  end
end
