# frozen_string_literal: true

module CheckMot
  class ByVehicleRegistrationResponse < Response
    def resource
      validate
      Resource.new(sanitized&.first)
    end
  end
end
