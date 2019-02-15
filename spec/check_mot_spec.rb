RSpec.describe CheckMot do
  it "has a version number" do
    expect(CheckMot::VERSION).not_to be nil
  end

  describe 'configuration' do
    it 'enables the api_key to be set' do
      api_key = SecureRandom.urlsafe_base64(16)
      CheckMot.configure do |config|
        config.api_key = api_key
      end
      expect(CheckMot.configuration.api_key).to eq api_key
    end

    it 'ignores any amends directly on the returned configuration object' do
      api_key = SecureRandom.urlsafe_base64(16)
      CheckMot.configure do |config|
        config.api_key = api_key
      end
      CheckMot.configuration.api_key = 'some_override'
      expect(CheckMot.configuration.api_key).to eq api_key
    end
  end
end
