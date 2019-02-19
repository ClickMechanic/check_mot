RSpec.describe CheckMot::Attribute do
  let(:value) { 'some value' }

  describe '.resolve' do
    let(:name) { :test_date }

    subject { described_class.resolve(name, value) }

    context 'for date attributes' do
      it 'returns a DateAttribute' do
        result = double :result
        expect(CheckMot::DateAttribute).to receive(:new).with(value).and_return(result)
        expect(subject).to be result
      end
    end

    context 'for non-date attributes' do
      let(:name) { :test_nondate }

      it 'returns the value verbatim' do
        expect(subject).to be value
      end
    end
  end
end
