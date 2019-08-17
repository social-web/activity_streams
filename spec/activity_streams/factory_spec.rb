# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Factory do
    it 'deeply inits' do
      json = File.read(
        File.join(__dir__, '../fixtures/extended_activity.json')
      )

      collection = described_class.new(json).build
      expect(collection.original_json).to eq(json)
      expect(collection).to be_a (ActivityStreams::Collection)
      expect(collection.valid?).to eq(true)
      expect(collection._context).
        to eq('https://www.w3.org/ns/activitystreams')
      expect(collection._context).to eq('https://www.w3.org/ns/activitystreams')
      expect(collection.type).to eq('Collection')

      expect(collection.items).to be_a(Array)

      add = collection.items.first
      expect(add).to be_a(ActivityStreams::Activity::Add)
      expect(add.published).to be_a(Time)

      actor = add.actor
      expect(actor).to be_a(ActivityStreams::Actor)
      expect(actor.image).to be_a(ActivityStreams::Link)

      object = add.object
      expect(object).to be_a(ActivityStreams::Object::Image)

      target = add.target
      expect(target).to be_a(ActivityStreams::Collection)
    end

    it 'does not raise an error when it receives an unsupported type' do
      json = <<~JSON
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Nope"
        }
      JSON

      expect { described_class.new(json).build }.
        to raise_error(ActivityStreams::UnsupportedType)
    end

    it 'loads a context' do
      ctx1 = 'https://example.com/ns'
      mod1 = Module.new { ActivityStreams.register_context(ctx1, self) }

      ctx2 = 'https://example.org/ns'
      mod2 = Module.new { ActivityStreams.register_context(ctx2, self) }

      json = %({
        "@context": [
          "https://www.w3.org/ns/activitystreams",
          "#{ctx1}",
          "#{ctx2}"
          ],
        "type": "Create"
      })

      act = described_class.new(json).build
      expect(act.singleton_class.ancestors).to include(mod1)
      expect(act.singleton_class.ancestors).to include(mod2)
    end
  end
end
