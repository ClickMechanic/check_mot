# frozen_string_literal: true

module CheckMot
  class ByVehicleRegistrationRequest < Request
    def get(registration)
      response = super(registration: registration)
      response.validate
      Resource.new(response.sanitized&.first)
    end
  end
end
