RSpec.describe CheckMot::Client do
  let(:status) { 200 }
  let(:http_response) { double :http_response, body: response_body, status: status, success?: status == 200, not_found?: status == 404}
  let(:connection) { double :connection }
  let(:api_key) { SecureRandom.urlsafe_base64(16) }
  let(:configuration) { double(:config, api_key: api_key, http_adapter: nil) }
  let(:client) { described_class.new }

  subject { client }

  before { allow(CheckMot).to receive(:configuration).and_return(configuration) }

  describe '#by_vehicle_registration' do
    let(:response_body) { File.read(File.expand_path('../fixtures/registration.json', __FILE__)) }
    let(:registration) { 'ABC123' }

    subject { client.by_vehicle_registration(registration) }

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

  describe '#by_date' do
    let(:response_body) { File.read(File.expand_path('../fixtures/date.json', __FILE__)) }
    let(:date) { '20240101' }
    let(:page) { 1 }
    let(:response) { CheckMot::Response.new(http_response) }

    subject { client.by_date(date, page: page) }

    before do
      allow(connection).to receive(:get).and_return(http_response)
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it 'returns an array of Resources containing the response data' do
      allow_any_instance_of(CheckMot::Request).to receive(:get).with(date: date, page: page).and_return(response)
      resource_1 = double(:resource_1)
      resource_2 = double(:resource_2)
      expect(CheckMot::Resource).to receive(:new).with(response.sanitized[0]).and_return resource_1
      expect(CheckMot::Resource).to receive(:new).with(response.sanitized[1]).and_return resource_2

      expect(subject).to contain_exactly resource_1, resource_2
    end

    context 'when the response is not successful' do
      let(:success?) { false }

      context 'when the response is a 404' do
        let(:status) { 404 }
        let(:response_body) { File.read(File.expand_path('../fixtures/404_vrm.json', __FILE__)) }

        it { is_expected.to match_array [] }
      end

      context 'when the response is non-successful code other than 404' do
        let(:status) { [400, 403, 415, 429, 500, 503, 504].sample }
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
end
