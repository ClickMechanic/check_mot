# frozen_string_literal: true

module CheckMot
  class ByVehicleRegistrationRequest < Request
    def get(registration)
      raw_response = get_raw(registration: registration)
      ByVehicleRegistrationResponse.new(raw_response).resource
    end
  end
end
