module CheckMot

  class Client
    def get(params)
      response = Response.new(connection.get path, params)
      fail ResponseError.new(response.status, response.raw) unless response.success?
      Resource.new(response.sanitized)
    end

    private

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

      Faraday.new(:url => url) do |builder|
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
