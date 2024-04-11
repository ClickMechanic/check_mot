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

    it 'calls get with the correct params' do
      expect(client).to receive(:get).with(registration: registration).and_call_original
      subject
    end

    it 'returns a Resource containing the first record from the response' do
      response = CheckMot::Response.new(http_response)
      expect(client).to receive(:get).with(registration: registration).and_return(response)

      resource = double(:resource)
      expect(CheckMot::Resource).to receive(:new).with(response.sanitized.first).and_return resource

      expect(subject).to be resource
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

    it 'calls get with the correct params' do
      expect(client).to receive(:get).with(date: date, page: page).and_call_original
      subject
    end

    it 'returns an array of Resources containing the response data' do
      expect(client).to receive(:get).with(date: date, page: page).and_return(response)

      resource_1 = double(:resource_1)
      resource_2 = double(:resource_2)
      expect(CheckMot::Resource).to receive(:new).with(response.sanitized[0]).and_return resource_1
      expect(CheckMot::Resource).to receive(:new).with(response.sanitized[1]).and_return resource_2

      expect(subject).to contain_exactly resource_1, resource_2
    end

    context 'when the response is a 404' do
      let(:response_body) { File.read(File.expand_path('../fixtures/empty_page.json', __FILE__)) }
      let(:status) { 404 }

      it 'returns an empty array' do
        expect(subject).to match_array([])
      end
    end
  end

  describe '#connection' do
    subject { client.send(:connection) }

    it 'initializes a Faraday object with the api url' do
      expect(Faraday).to receive(:new).with(url: 'https://beta.check-mot.service.gov.uk')
      subject
    end

    it 'adds the api_key header' do
      allow(Faraday).to receive(:new) do |_, &block|
        builder = double(:builder)
        expect(builder).to(receive(:headers)) { |headers| expect(headers).to include('x-api-key' => api_key) }
        block.call(builder)
      end
    end

    context 'when the api_key is not configured' do
      before { allow(configuration).to receive(:api_key).and_return nil }

      it 'raises an Error' do
        expect { subject }.to raise_error(CheckMot::Error, 'api_key not configured')
      end
    end
  end

  describe '#get' do
    let(:response_body) { '{}' }
    let(:params) { {registration: 'ABC123'} }

    subject { client.send(:get, params) }

    before do
      allow(connection).to receive(:get).and_return(http_response)
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it 'returns a Response' do
      response = double(:response, success?: true)
      expect(CheckMot::Response).to receive(:new).with(http_response).and_return(response)

      expect(subject).to be response
    end

    context 'when the response is not successful' do
      let(:status) { 400 }
      let(:success?) { false }
      let(:response_body) { 'This is an error' }

      it 'raises a ResponseError' do
        expect { subject }.to raise_error(CheckMot::ResponseError) do |e|
          expect(e.message).to eq response_body
          expect(e.status).to eq status
        end
      end
    end

    it 'passes the path in the call' do
      expect(connection).to receive(:get).with('/trade/vehicles/mot-tests', anything).and_return(http_response)
      subject
    end

    it 'passes the params in the call' do
      expect(connection).to receive(:get).with(anything, params).and_return(http_response)
      subject
    end
  end
end
