# frozen_string_literal: true

module ActivityStreams
  class Activity::Remove < Activity
    ActivityStreams.register_type('Remove', self)
  end
end
