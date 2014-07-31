require_dependency 'otrs/article'
require_dependency 'otrs/client'
require_dependency 'otrs/ticket'
require_dependency 'otrs/ticket_validator'

module Otrs
  
  # Check if otrs openreply API is being used.
  # Some validation logic depeneds on this.
  # It's configured in config/settings.yml in otrs section
  #
  # @return [TrueClass | FalseClass]
  def self.using_otrs?
    Settings.otrs_api.enabled
  end

  # This error is raised when otrs client can not connect to otrs
  # or there's an internal error or the response code is not 200
  class ServiceError < StandardError
  end

  # Error raised when no objects are returned from otrs,
  # the response itself is valid, but empty
  class IDNotFoundError < StandardError
  end
end
