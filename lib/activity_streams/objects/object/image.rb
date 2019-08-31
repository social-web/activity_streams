# frozen_string_literal: true

require 'activity_streams/objects/object/document'

module ActivityStreams
  class Object::Image < Object::Document
    ActivityStreams.register_type('Image', self)
  end
end
