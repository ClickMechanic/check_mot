# frozen_string_literal: true

module CheckMot
  class ByDateRequest < Request
    def get(date, page:)
      raw_response = get_raw(date: date, page: page)
      response = ByDateResponse.new(raw_response)
      return [] if response.status == 404

      response.validate

      response.sanitized.map { |source_hash| Resource.new(source_hash) }
    end
  end
end
