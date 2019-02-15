RSpec.describe CheckMot::Resource do
  let(:source_hash) { { test1: 'some value', method2: rand(100) } }
  let(:resource) { described_class.new(source_hash) }

  subject { resource }

  it { is_expected.to respond_to(:test1) }
  it { is_expected.to respond_to(:method2) }
  it { is_expected.not_to respond_to(:method3) }

  it 'provides method implementations for given hash' do
    expect(subject.test1).to eq 'some value'
    expect(subject.method2).to eq source_hash[:method2]
    expect { subject.method3 }.to raise_error(NoMethodError)
  end

  describe 'Hash attributes' do
    let(:source_hash) { { hash_attr: { test2: 'some value', method3: rand(100) } } }
    subject { resource.hash_attr }

    specify 'are resolved into Resource instances' do
      expect(subject).to be_a CheckMot::Resource
      expect(subject.test2).to eq 'some value'
      expect(subject.method3).to eq source_hash[:hash_attr][:method3]
    end
  end

  describe 'Array attributes' do
    let(:source_hash) { { array_attr: [rand(100), Object.new, 'some value', { test2: 'some value', method3: rand(100) }] } }
    subject { resource.array_attr }

    specify 'normal members are resolved to themselves' do
      (0..2).each do |i|
        expect(subject[i]).to be source_hash[:array_attr][i]
      end
    end

    describe 'Hash members' do
      subject { resource.array_attr[3] }

      specify 'are resolved into Resource instances' do
        expect(subject).to be_a CheckMot::Resource
        expect(subject.test2).to eq 'some value'
        expect(subject.method3).to eq source_hash[:array_attr][3][:method3]
      end
    end
  end

  describe 'Date attributes' do
    let(:date) { Date.today + rand(100) }
    let(:source_hash) { { unformatted_date: 'some date', formatted_date: date.strftime('%Y.%m.%d') } }

    specify 'are resolved into dates' do
      expect(subject.unformatted_date).to eq 'some date'
      expect(subject.formatted_date).to eq date
    end
  end

  describe 'Time attributes' do
    let(:time) { Time.now.change(usec: 0) }
    let(:source_hash) { { unformatted_date: 'some time', formatted_date: time.strftime('%Y.%m.%d %H:%M:%S') } }

    specify 'are resolved into times' do
      expect(subject.unformatted_date).to eq 'some time'
      expect(subject.formatted_date).to eq time
    end
  end
end
