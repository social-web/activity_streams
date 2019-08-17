# frozen_string_literal: true

module ActivityStreams
  class Link < ActivityStreams::Model
    ActivityStreams.register_type('Link', self)
    %i[
      href
      rel
      mediaType
      name
      hreflang
      height
      width
      preview
    ].each(&method(:property))
  end
end
