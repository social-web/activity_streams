# frozen_string_literal: true

module ActivityStreams
  class Object::Article < Object
    ActivityStreams.register_type('Article', self)
  end
end
