RSpec.describe CheckMot::ByDateResponse do
  let(:unit) { described_class.new(http_response) }

  describe '#resources' do
    let(:status) { 200 }
    let(:http_response) { double :http_response, body: response_body, status: status, success?: status == 200, not_found?: status == 404}

    let(:response_body) { File.read(File.expand_path('../fixtures/date.json', __FILE__)) }

    subject { unit.resources }

    it 'returns an array of Resources containing the response data' do
      expect(subject.map(&:registration)).to contain_exactly 'YC15ZTE', 'F5TMB'
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
