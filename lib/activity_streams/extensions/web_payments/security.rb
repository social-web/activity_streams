# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module WebPayments
      module Security
        ActivityStreams::Model.register_context(
          'https://w3id.org/security/v1',
          self
        )

        def self.extended(base)
          base.class_eval do
            attribute :id
            attribute :owner
            attribute :publicKey
            attribute :publicKeyPem
          end
        end
      end
    end
  end
end
