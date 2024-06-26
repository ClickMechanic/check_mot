require 'date'
require "active_support"
require 'active_support/core_ext/time'
require 'json'
require 'faraday'

require 'check_mot/version'
require 'check_mot/configuration'
require 'check_mot/attribute'
require 'check_mot/date_attribute'
require 'check_mot/resource'
require 'check_mot/request'
require 'check_mot/response'
require 'check_mot/by_vehicle_registration_request'
require 'check_mot/by_date_request'
require 'check_mot/by_vehicle_registration_response'
require 'check_mot/by_date_response'
require 'check_mot/client'

module CheckMot
  class Error < StandardError; end

  class ResponseError < StandardError
    attr_reader :status

    def initialize(status, message)
      super(message)
      @status = status
    end
  end

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
