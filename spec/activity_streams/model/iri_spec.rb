# frozen_string_literal: true

require 'spec_helper'

module ActivityStreams
  RSpec.describe IRI do
    describe "#{described_class::IsResolveable}" do
      it 'returns true for a URI' do
        expect(
          described_class::IsResolveable.call(:object, 'http://example.com')
        ).to eq(true)
      end

      it 'returns for false for a non-URI string' do
        expect(
          described_class::IsResolveable.call(:object, 'boop')
        ).to eq(false)
      end
    end

    describe "#{described_class::Dereference}" do
      it 'expects a json response' do
        response = instance_double(
          'HTTP::Response',
          headers: { 'content-type' => 'invalid' }
        )
        allow_any_instance_of(HTTP::Client).
          to receive(:get).
          and_return(response)

        expect { described_class::Dereference.call('') }.
          to raise_error(ActivityStreams::IRI::IRIDereferencingError)
      end

      context 'response status' do
        context '200' do
          it 'returns an ActivityStreams object' do
            body = '{ type: Create }'
            response = instance_double(
              'HTTP::Response',
              headers: { 'content-type' => 'json' },
              status: 200,
              body: body
            )
            allow_any_instance_of(HTTP::Client).
              to receive(:get).
              and_return(response)

            expect(ActivityStreams).to receive(:from_json).with(body)
            described_class::Dereference.call('')
          end
        end

        context '300' do
          it 'follows the redirect' do
            location = 'new location'
            response = instance_double(
              'HTTP::Response',
              headers: { 'content-type' => 'json', 'Location' => location },
              status: 300
            )
            allow_any_instance_of(HTTP::Client).
              to receive(:get).
                and_return(response)

            expect(described_class::Dereference).
              to receive(:call).
                with('').
                and_call_original.
                ordered

            expect(described_class::Dereference).
              to receive(:call).
                with(location).
                and_return(nil).
                ordered

            described_class::Dereference.call('')
          end
        end

        context '400' do
          it 'raises an error' do
            response = instance_double(
              'HTTP::Response',
              headers: { 'content-type' => 'json' },
              status: 400
            )
            allow_any_instance_of(HTTP::Client).
              to receive(:get).
              and_return(response)

            expect { described_class::Dereference.call('') }.
              to raise_error(ActivityStreams::IRI::IRIDereferencingError)
          end
        end
      end
    end
  end
end
