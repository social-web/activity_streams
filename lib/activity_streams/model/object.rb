# frozen_string_literal: true

module ActivityStreams
  class Object < ActivityStreams::Model
    %w[
      attachment attributedTo audience
      bcc bto
      cc content context
      duration
      endTime
      generator
      icon id image inReplyTo
      location
      mediaType
      name
      preview published
      replies
      startTime summary
      tag
      updated url
      to
    ].each(&method(:attribute))

    attribute :published, :datetime
    attribute :startTime, :datetime
    attribute :updated, :datetime
  end
end

Dir[File.join(__dir__, 'object', '*.rb')].each { |f| require f }
