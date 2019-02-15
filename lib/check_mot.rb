require 'date'
require 'active_support/core_ext/time'
require 'json'

require 'check_mot/version'
require 'check_mot/configuration'
require 'check_mot/attribute'
require 'check_mot/date_attribute'
require 'check_mot/resource'
require 'check_mot/response'

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
