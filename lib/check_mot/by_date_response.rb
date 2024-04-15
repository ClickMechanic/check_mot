# frozen_string_literal: true

module CheckMot
  class ByDateResponse < Response
    def resources
      return [] if status == 404

      validate

      sanitized.map { |source_hash| Resource.new(source_hash) }
    end
  end
end
