module CheckMot

  class Response
    def initialize(raw_response)
      @raw_response = raw_response
    end

    delegate :success?, :status, to: :raw_response

    def raw
      raw_response.body
    end

    def validate
      fail ResponseError.new(status, raw) unless success?
    end

    protected

    def parsed_response
      @_parsed_response ||= JSON.parse(raw_response.body)
    end

    private

    attr_reader :raw_response

    def transform(response_hash)
      response_hash.deep_transform_keys { |key| key.underscore.to_sym }
    end
  end

end
