# frozen_string_literal: true

module CheckMot
  class ByDateRequest < Request
    def get(date, page:)
      raw_response = get_raw(date: date, page: page)
      ByDateResponse.new(raw_response).resources
    end
  end
end
