# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module WebPayments
      module Security
        ActivityStreams.register_context('https://w3id.org/security/v1', self)

        def self.extended(mod)
          mod.class_eval do
            property :signature
            property :publicKey
            property :publicKeyPem
          end
        end
      end
    end
  end
end
