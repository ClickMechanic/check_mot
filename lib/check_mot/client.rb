module CheckMot
  class Client
    def by_vehicle_registration(registration)
      response = ByVehicleRegistrationRequest.new.get(registration: registration)

      response.validate

      Resource.new(response.sanitized&.first)
    end

    def by_date(date, page:)
      response = ByDateRequest.new.get(date: date, page: page)
      return [] if response.status == 404

      response.validate

      response.sanitized.map { |source_hash| Resource.new(source_hash) }
    end
  end
end
