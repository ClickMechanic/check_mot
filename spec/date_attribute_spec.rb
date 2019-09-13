RSpec.describe CheckMot::DateAttribute do
  let(:value) { 'some value' }

  let(:attribute) { described_class.new(value) }

  describe '#value' do
    subject { attribute.value }

    context 'for non date/time' do
      it 'returns the value verbatim' do
        expect(subject).to eq value
      end
    end

    context 'for date' do
      let(:date) { Date.today }
      let(:value) { date.strftime('%Y.%m.%d') }

      it 'returns the value converted to a date' do
        expect(subject).to eq date
      end
    end

    context 'for time' do
      let(:time) { Time.now.change(usec: 0) }
      let(:value) { time.strftime('%Y.%m.%d %H:%M:%S') }

      it 'returns the value converted to a time' do
        expect(subject).to eq time
      end
    end
  end

  describe '.try' do
    let(:name) { :test_date }
    subject { described_class.try(name, value) }

    context 'for date attributes' do
      it 'returns an instance of DateAttribute' do
        expect(subject).to be_a(CheckMot::DateAttribute)
        expect(subject.value).to eq value
      end
    end

    context 'for non-date attributes' do
      let(:name) { :test_nondate }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
