# frozen_string_literal: true

module ActivityStreams
  def self.from_uri(uri)
    IRI::Dereference.call(uri)
  end

  class IRI
    class IRIDereferencingError < ActivityStreams::Error; end

    DEFAULT_HEADERS = {
      'accept': 'application/ld+json; ' \
        'profile="https://www.w3.org/ns/activitystreams", '\
        'application/ld+json, '\
        'application/activity+json, '\
        'application/json'
    }.freeze

    IsResolveable = ->(prop, value) {
      value.is_a?(String) &&
        !%i[href id url].include?(prop) &&
        value.match?(::URI.regexp(%w[http https]))
    }

    Dereference = ->(iri) {
      return if iri.match?(ActivityStreams.config.domain)

      res = HTTP.headers(DEFAULT_HEADERS).get(iri)
      unless res.content_type.mime_type.match?(/json/)
        raise IRIDereferencingError.new "Unable to dereference \"#{iri}\". " \
          "Invalid content-type: #{res.headers['content-type']}"
        MSG
      end

      case res.status
      when 200..299 then
        body = res.body.to_s.encode(
          'UTF-8',
          'UTF-8',
          invalid: :replace,
          replace: ''
        )
        ActivityStreams.from_json(body)
      when 300..399 then IRI::Dereference.call(res.headers['Location'])
      when 400..499
        raise IRIDereferencingError.new <<~MSG
          Unable to dereference "#{iri}". Received status: #{res.status}.
        MSG
      when 500..599 then # retry?
      end
    }
  end
end
