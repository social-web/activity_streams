# frozen_string_literal: true

module ActivityStreams
  class Object::Image < Object
    ActivityStreams.register_type('Image', self)
  end
end
