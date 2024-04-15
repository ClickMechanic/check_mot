# frozen_string_literal: true

module CheckMot
  class ByDateRequest < Request
    def get(date, page:)
      response = super(date: date, page: page)
      return [] if response.status == 404

      response.validate

      response.sanitized.map { |source_hash| Resource.new(source_hash) }
    end
  end
end
