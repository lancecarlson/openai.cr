require "spec"
require "webmock"
require "../src/openai"

WebMock.allow_net_connect = true

OpenAI.configure do |config|
  config.access_token = access_token
end

def request_headers
  HTTP::Headers{
    "Authorization" => "Bearer #{access_token}",
    "Content-Type"  => "application/json",
  }
end

def access_token
  ENV.fetch("OPENAI_ACCESS_TOKEN")
end
