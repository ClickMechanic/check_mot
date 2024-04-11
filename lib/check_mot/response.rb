module CheckMot

  class Response
    def initialize(raw_response)
      @raw_response = raw_response
    end

    delegate :success?, :not_found?, :status, to: :raw_response


    def sanitized
      return unless success?

      case parsed_response
      when Array
        parsed_response.map(&method(:transform))
      else
        transform(parsed_response)
      end
    end

    def raw
      raw_response.body
    end

    private

    attr_reader :raw_response

    def transform(response_hash)
      response_hash.deep_transform_keys { |key| key.underscore.to_sym }
    end

    def parsed_response
      @_parsed_response ||= JSON.parse(raw_response.body)
    end
  end

end
