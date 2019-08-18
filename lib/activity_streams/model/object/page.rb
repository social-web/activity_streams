# frozen_string_literal: true

require 'activity_streams/model/object/document'

module ActivityStreams
  class Object::Page < Object::Document
    ActivityStreams.register_type('Page', self)
  end
end
