# frozen_string_literal: true

module CheckMot
  class Request
    URL = 'https://beta.check-mot.service.gov.uk'
    PATH = '/trade/vehicles/mot-tests'

    def get(params)
      Response.new(connection.get PATH, params)
    end

    private

    def connection
      @connection ||= create_connection
    end

    def create_connection
      fail Error.new('api_key not configured') unless CheckMot.configuration.api_key

      Faraday.new(url: URL) do |builder|
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
