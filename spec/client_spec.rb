RSpec.describe CheckMot::Client do
  let(:unit) { described_class.new }

  describe '#by_date' do
    subject { unit.by_date('20240101', page: 1) }
    let(:date_request) { double(:request, get: nil) }

    it 'constructs a ByDateRequest and calls get' do
      expect(CheckMot::ByDateRequest).to receive(:new).and_return(date_request)
      expect(date_request).to receive(:get).with('20240101', page: 1)
      subject
    end
  end

  describe '#by_vehicle_registration' do
    subject { unit.by_vehicle_registration('ABC123') }
    
    let(:reg_request) { double(:request, get: nil) }

    it 'constructs a ByVehicleRegistrationRequest and calls get' do
      expect(CheckMot::ByVehicleRegistrationRequest).to receive(:new).and_return(reg_request)
      expect(reg_request).to receive(:get).with('ABC123')
      subject
    end
  end
end
