RSpec.describe CheckMot::Request do
  let(:api_key) { SecureRandom.urlsafe_base64(16) }
  let(:configuration) { double(:config, api_key: api_key, http_adapter: nil) }
  let(:request) { described_class.new }

  subject { request }

  before { allow(CheckMot).to receive(:configuration).and_return(configuration) }

  describe '#connection' do
    subject { request.send(:connection) }

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

  describe '#get_raw' do
    let(:response_body) { '{}' }
    let(:status) { 200 }
    let(:http_response) { double :http_response, body: response_body, status: status, success?: status == 200, not_found?: status == 404}
    let(:connection) { double :connection }
    let(:params) { {registration: 'ABC123'} }

    subject { request.get_raw(params) }

    before do
      allow(connection).to receive(:get).and_return(http_response)
      allow(Faraday).to receive(:new).and_return(connection)
    end

    it 'passes the path in the call' do
      expect(connection).to receive(:get).with('/trade/vehicles/mot-tests', anything).and_return(http_response)
      expect(subject).to be(http_response)
    end
  end
end
