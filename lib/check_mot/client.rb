module CheckMot
  class Client
    def by_vehicle_registration(registration)
      ByVehicleRegistrationRequest.new.get(registration)
    end

    def by_date(date, page:)
      ByDateRequest.new.get(date, page: page)
    end
  end
end
