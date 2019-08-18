# frozen_string_literal: true

module ActivityStreams
  class Object::Place < Object
    ActivityStreams.register_type('Place', self)

    %i[accuracy altitude latitude longitude radius units].each(&method(:property))
  end
end
