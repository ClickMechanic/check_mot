# frozen_string_literal: true

module CheckMot
  class ByVehicleRegistrationRequest < Request
    def get(registration)
      raw_response = get_raw(registration: registration)
      response = ByVehicleRegistrationResponse.new(raw_response)
      response.validate
      Resource.new(response.sanitized&.first)
    end
  end
end
