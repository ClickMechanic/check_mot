RSpec.describe CheckMot::ByVehicleRegistrationRequest do
  let(:unit) { described_class.new }

  describe '#get' do
    let(:status) { 200 }
    let(:http_response) { double :http_response, body: response_body, status: status, success?: status == 200, not_found?: status == 404}
    let(:connection) { double :connection }
    let(:api_key) { SecureRandom.urlsafe_base64(16) }
    let(:configuration) { double(:config, api_key: api_key, http_adapter: nil) }

    before { allow(CheckMot).to receive(:configuration).and_return(configuration) }

    let(:response_body) { File.read(File.expand_path('../fixtures/registration.json', __FILE__)) }
    let(:registration) { 'ABC123' }

    subject { unit.get(registration) }

    before do
      allow(connection).to receive(:get).and_return(http_response)
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it 'returns a Resource containing the first record from the response' do
      response = CheckMot::Response.new(http_response)
      allow_any_instance_of(CheckMot::Request).to receive(:get).with(registration: registration).and_return(response)

      resource = double(:resource)
      expect(CheckMot::Resource).to receive(:new).with(response.sanitized.first).and_return resource

      expect(subject).to be resource
    end

    context 'when the response is non-successful code' do
      let(:success?) { false }
      let(:status) { [400, 403, 404, 415, 429, 500, 503, 504].sample }
      let(:response_body) { 'This is an error' }

      it 'raises a ResponseError' do
        expect { subject }.to raise_error(CheckMot::ResponseError) do |e|
          expect(e.message).to eq response_body
          expect(e.status).to eq status
        end
      end
    end
  end
end
