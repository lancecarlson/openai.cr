require "http/client"
require "json"
require "json-schema"

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
    property :base_url

    DEFAULT_BASE_URL = "https://api.openai.com"
    DEFAULT_API_VERSION = "v1"

    def initialize(@access_token : String | Nil = nil, @api_version = DEFAULT_API_VERSION, @organization_id : String | Nil = nil, @base_url = DEFAULT_BASE_URL)
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

  record FunctionRequest, name : String, description : String, parameters : JSON::Any do
    include JSON::Serializable

    def to_h
      {name: @name, description: @description, parameters: @parameters}
    end
  end

  def self.def_function(name, description, type)
    parameters = JSON.parse(type.json_schema.to_json)
    schema = FunctionRequest.new(name, description, parameters)
  end
end
