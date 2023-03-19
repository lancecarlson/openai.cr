require "spec"
require "webmock"
require "../src/openai"

WebMock.allow_net_connect = true

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
end

def request_headers
  access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  HTTP::Headers{
    "Authorization" => "Bearer #{access_token}",
    "Content-Type"  => "application/json",
  }
end
