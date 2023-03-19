require "http/client"
require "json"

require "./responses"
require "./models"
require "./client"

# TODO: Write documentation for `Openai`
module OpenAI
  class ConfigurationError < Exception; end

  VERSION = "0.1.0"

  class Configuration
    setter :access_token
    property :api_version
    property :organization_id

    DEFAULT_API_VERSION = "v1"

    def initialize(@access_token : String | Nil = nil, @api_version = DEFAULT_API_VERSION, @organization_id : String | Nil = nil)
    end

    def access_token
      return @access_token if @access_token

      error_text = "OpenAI access token missing!"
      raise ConfigurationError.new(error_text)
    end
  end

  class_setter configuration

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
