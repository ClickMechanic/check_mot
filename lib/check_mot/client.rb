module CheckMot

  class Client
    def by_vehicle_registration(registration)
      response = get(registration: registration)
      return nil if response.status == 404

      Resource.new(response.sanitized&.first)
    end

    def by_date(date, page:)
      response = get(date: date, page: page)
      return [] if response.status == 404

      response.sanitized.map { |source_hash| Resource.new(source_hash) }
    end

    private

    def get(params)
      Response.new(connection.get path, params).tap do |response|
        fail ResponseError.new(response.status, response.raw) unless valid_response?(response)
      end
    end

    def valid_response?(response)
      response.success? || response.status == 404
    end

    def url
      'https://beta.check-mot.service.gov.uk'
    end

    def path
      '/trade/vehicles/mot-tests'
    end

    def connection
      @connection ||= create_connection
    end

    def create_connection
      fail Error.new('api_key not configured') unless CheckMot.configuration.api_key

      Faraday.new(url: url) do |builder|
        builder.headers = headers
        builder.adapter CheckMot.configuration.http_adapter || Faraday.default_adapter
      end
    end

    def headers
      {
          'Accept': 'application/json+v6',
          'x-api-key': CheckMot.configuration.api_key
      }
    end
  end

end
