require 'spec_helper'

module EventbriteSDK
  RSpec.describe Event do
    before do
      EventbriteSDK.token = 'token'
    end

    describe '.retrieve' do
      context 'when found' do
        it 'returns a new instance' do
          stub_endpoint(
            path: 'events/1234',
            body: :event_read,
          )
          event = described_class.retrieve id: '1234'

          expect(event).to be_an_instance_of(described_class)
        end
      end

      context 'when not found' do
        it 'throws some sort of error' do
          stub_endpoint(
            path: 'events/10000',
            status: 404,
            body: :event_not_found,
          )

          expect { described_class.retrieve id: '10000' }.
            to raise_error('requested object was not found')
        end
      end
    end

    describe '.build' do
      it 'returns a hydrated instance' do
        event = described_class.build('name.html' => 'An Event')

        expect(event.name.html).to eq('An Event')
      end
    end

    describe '#cancel' do
      context 'when id exists' do
        it 'calls save with `cancel`' do
          event = described_class.new('id' => '1')
          allow(event).to receive(:save)

          event.cancel

          expect(event).to have_received(:save).with('cancel')
        end
      end

      context 'when id is absent' do
        it 'returns false' do
          event = described_class.new
          allow(event).to receive(:save)

          expect(event.cancel).to eq(false)
        end
      end
    end

    describe '#orders' do
      context 'when event is new' do
        it 'instantiates an empty ResourceList' do
          expect(subject.orders).to be_an_instance_of(ResourceList)
          expect(subject.orders).to be_empty
        end
      end

      context 'when event exists' do
        it 'hydrates a list of Orders' do
          stub_get(
            path: 'events/31337',
            fixture: :event_read,
            override: { 'id' => '31337' },
          )
          stub_get(path: 'events/31337/orders/?page=1', fixture: :event_orders)

          event = described_class.retrieve(id: '31337')

          event.orders.retrieve

          expect(event.orders).to be_an_instance_of(ResourceList)
          expect(event.orders.first).to be_an_instance_of(Order)
        end
      end
    end

    describe '#ticket_classes' do
      context 'when event is new' do
        it 'instantiates an empty ResourceList' do
          expect(subject.ticket_classes).to be_an_instance_of(ResourceList)
          expect(subject.ticket_classes).to be_empty
        end
      end

      context 'when event exists' do
        it 'hydrates a list of TicketClasses' do
          stub_get(
            path: 'events/31337',
            fixture: :event_read,
            override: { 'id' => '31337' },
          )
          stub_get(
            path: 'events/31337/ticket_classes/?page=1',
            fixture: :event_ticket_classes
          )

          event = described_class.retrieve(id: '31337')
          event.ticket_classes.retrieve

          expect(event.ticket_classes).to be_an_instance_of(ResourceList)
          expect(event.ticket_classes.first).to be_an_instance_of(TicketClass)
        end
      end
    end

    describe '#publish' do
      context 'when id exists' do
        it 'calls save with the called method name' do
          event = described_class.new('id' => '1')
          allow(event).to receive(:save)

          event.publish

          expect(event).to have_received(:save).with('publish')
        end
      end

      context 'when id is absent' do
        it 'returns false' do
          event = described_class.new
          allow(event).to receive(:save)

          expect(event.publish).to eq(false)
        end
      end
    end

    describe '#unpublish' do
      context 'when id exists' do
        it 'calls save with the called method name' do
          event = described_class.new('id' => '1')
          allow(event).to receive(:save)

          event.unpublish

          expect(event).to have_received(:save).with('unpublish')
        end
      end

      context 'when id is absent' do
        it 'returns false' do
          event = described_class.new
          allow(event).to receive(:save)

          expect(event.unpublish).to eq(false)
        end
      end
    end
  end
end
