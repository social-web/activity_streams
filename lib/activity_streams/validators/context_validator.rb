# frozen_string_literal: true

module ActivityStreams
  module Validators
    # Example:
    # {
    #   "@context": [
    #     "https://www.w3.org/ns/activitystreams",
    #     "https://w3id.org/security/v1",
    #     {
    #       "manuallyApprovesFollowers": "as:manuallyApprovesFollowers",
    #       "toot": "http://joinmastodon.org/ns#",
    #       "featured": {
    #         "@id": "toot:featured",
    #         "@type": "@id"
    #       },
    #       "alsoKnownAs": {
    #         "@id": "as:alsoKnownAs",
    #         "@type": "@id"
    #       },
    #       "movedTo": {
    #         "@id": "as:movedTo",
    #         "@type": "@id"
    #       },
    #       "schema": "http://schema.org#",
    #       "PropertyValue": "schema:PropertyValue",
    #       "value": "schema:value",
    #       "Hashtag": "as:Hashtag",
    #       "Emoji": "toot:Emoji",
    #       "IdentityProof": "toot:IdentityProof",
    #       "focalPoint": {
    #         "@container": "@list",
    #         "@id": "toot:focalPoint"
    #       }
    #     }
    #   ]
    # }
    ContextValidator = lambda do |obj|
      ctx = obj._context
      return if case ctx
        when Array then ctx.include?
      end

      obj.errors.add(
        :'@context',
        "@context is unsupported. Must be #{Model::CONTEXT}, got #{ctx || 'nil'}"
      )
    end

    def string_or_array_includes?(obj)

    end
  end
end
