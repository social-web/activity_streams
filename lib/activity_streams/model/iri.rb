# frozen_string_literal: true

module ActivityStreams
  class IRI
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

    Resolve = ->(iri) {
      res = HTTP.follow.headers(DEFAULT_HEADERS).get(iri)
      if res.status.success? && res.headers['content-type'].match?(/json/)
        body = res.body.to_s.encode(
          'UTF-8',
          'UTF-8',
          invalid: :replace,
          replace: ''
        )
        ActivityStreams.from_json(body)
      else
        iri
      end
    }
  end
end
