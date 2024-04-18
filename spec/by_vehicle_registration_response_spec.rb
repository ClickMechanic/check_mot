RSpec.describe CheckMot::ByVehicleRegistrationResponse do
  let(:unit) { described_class.new(http_response) }

  describe '#resource' do
    let(:status) { 200 }
    let(:http_response) { double :http_response, body: response_body, status: status, success?: status == 200, not_found?: status == 404}

    let(:response_body) { File.read(File.expand_path('../fixtures/registration.json', __FILE__)) }

    subject { unit.resource }

    it 'returns a Resource containing the first record from the response' do
      expect(subject).to be_a CheckMot::Resource
      expect(subject.registration).to eq 'AK07LFT'
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
