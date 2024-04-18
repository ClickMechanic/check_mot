RSpec.describe CheckMot::ByVehicleRegistrationRequest do
  let(:unit) { described_class.new }
  let(:api_key) { SecureRandom.urlsafe_base64(16) }
  let(:configuration) { double(:config, api_key: api_key, http_adapter: nil) }
  let(:connection) { double :connection }


  before do
    allow(CheckMot).to receive(:configuration).and_return(configuration)
    allow_any_instance_of(CheckMot::Request).to receive(:get_raw).with(registration: registration).and_return(http_response)

    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:get_raw).and_return(http_response)
  end

  describe '#get' do
    let(:http_response) { double :http_response }
    let(:registration) { 'ABC123' }
    let(:resource) { instance_double(CheckMot::Resource) }
    let(:response) { instance_double(CheckMot::ByVehicleRegistrationResponse, resource: resource) }

    subject { unit.get(registration) }

    before do
      allow(CheckMot::ByVehicleRegistrationResponse).to receive(:new).with(http_response).and_return(response)
    end

    it 'returns a Resource obtained from the Response' do
      expect(subject).to be resource
    end
  end
end
