# frozen_string_literal: true

module ActivityStreams
  class Object::Profile < Object
    ActivityStreams.register_type('Profile', self)

    property :describes
  end
end
