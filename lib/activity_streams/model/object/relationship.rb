# frozen_string_literal: true

module ActivityStreams
  class Object::Relationship < Object
    ActivityStreams.register_type('Relationship', self)

    %i[subject object relationship].each(&method(:property))
  end
end
