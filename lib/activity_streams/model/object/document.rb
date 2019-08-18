# frozen_string_literal: true

module ActivityStreams
  class Object::Document < Object
    ActivityStreams.register_type('Document', self)
  end
end
