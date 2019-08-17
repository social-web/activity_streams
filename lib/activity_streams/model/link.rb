# frozen_string_literal: true

module ActivityStreams
  class Link < ActivityStreams::Model
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
