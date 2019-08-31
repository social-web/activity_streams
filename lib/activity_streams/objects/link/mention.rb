# frozen_string_literal: true

module ActivityStreams
  class Link::Mention < Link
    ActivityStreams.register_type('Mention', self)
  end
end
