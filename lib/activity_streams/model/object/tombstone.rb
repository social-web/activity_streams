# frozen_string_literal: true

module ActivityStreams
  class Object::Tombstone < Object
    ActivityStreams.register_type('Tombstone', self)

    property :formerType
    property :deleted, PropertyTypes::Params::Time
  end
end
