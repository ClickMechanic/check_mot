# frozen_string_literal: true

module CheckMot
  class ByVehicleRegistrationResponse < Response
    def resource
      validate
      Resource.new(sanitized)
    end

    def sanitized
      transform(parsed_response.first)
    end
  end
end
