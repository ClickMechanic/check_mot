require "check_mot/version"
require "check_mot/configuration"

module CheckMot
  class Error < StandardError; end

  class << self
    def configure
      yield _configuration
    end

    def configuration
      _configuration.dup
    end

    private

    def _configuration
      @_configuration ||= Configuration.new
    end
  end
end
