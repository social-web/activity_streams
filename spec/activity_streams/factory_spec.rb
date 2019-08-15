# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe Factory do
    it 'deeply inits' do
      json = File.read(
        File.join(__dir__, 'fixtures/extended_activity.json')
      )

      collection = described_class.new(json).build
      expect(collection.original_json).to eq(json)
      expect(collection).to be_a(ActivityStreams::Collection)
      expect(collection.valid?).to eq(true)
      expect(collection.send(:'@context')).
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

    it 'raise an error when it recieves an unsupported type' do
      json = <<~JSON
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Nope"
        }
      JSON

      expect { described_class.new(json).build }.
        to raise_error(ActivityStreams::UnsupportedType, 'Nope')
    end
  end
end
