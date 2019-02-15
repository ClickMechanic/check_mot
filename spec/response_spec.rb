RSpec.describe CheckMot::Response do
  let(:success) { true }
  let(:status) { rand(100) }
  let(:body_hash) {
      {
          "camelCaseKey" => 'some value',
          "parentKey" => {
              "childNode" => rand(100),
              "siblingChild" => {
                  "grandchildNode" => 'a test attribute'
              }
          }
      }
  }

  let(:body) { [body_hash].to_json }
  let(:raw_response) { double(:response, success?: success, status: status ,body: body )}
  let(:response) { described_class.new(raw_response) }

  subject { response }

  describe '#success?' do
    let(:success) { [true, false].sample }

    it "delegates to the raw response" do
      expect(subject.success?).to eq success
    end
  end

  describe '#status?' do
    it "delegates to the raw response" do
      expect(subject.status).to eq status
    end
  end

  describe 'raw' do
    it 'returns the raw response body' do
      expect(subject.raw).to eq raw_response.body
    end
  end

  describe 'sanitized' do
    subject { response.sanitized }

    it 'returns an array of hashes with keys transformed with underscores and symbolized' do
      expected = [{
          camel_case_key: 'some value',
          parent_key: {
              child_node: body_hash["parentKey"]["childNode"],
              sibling_child: {
                  grandchild_node: 'a test attribute'
              }
          }
      }]

      expect(subject).to eq expected
    end

    context 'when the raw response is not successful' do
      let(:success) { false }

      it { is_expected.to be_nil }
    end
  end
end
