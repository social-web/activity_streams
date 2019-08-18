# frozen_string_literal: true

require 'activity_streams/model/object/document'

module ActivityStreams
  class Object::Video < Object::Document
    ActivityStreams.register_type('Video', self)
  end
end
