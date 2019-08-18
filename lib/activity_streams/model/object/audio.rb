# frozen_string_literal: true

require 'activity_streams/model/object/document'

module ActivityStreams
  class Object::Audio < Object::Document
    ActivityStreams.register_type('Audio', self)
  end
end
