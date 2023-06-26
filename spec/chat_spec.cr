require "./spec_helper"

# Custom log backend to store log entries in an array.
class ArrayLogBackend < Log::IOBackend
  getter logs : Array(String)

  def initialize(@logs = [] of String)
    super(String::Builder.new) # Using a String::Builder as a placeholder.
  end

  def write(entry : Log::Entry)
    @logs << entry.to_s
  end
end

class CatNameResponse
  include JSON::Serializable

  @[JSON::Field(description: "A name of a cat")]
  getter cats : Array(String)
end

describe OpenAI do
  describe "chat" do
    # WebMock.stub(:post, "https://api.openai.com/v1/chat/completions")
    #  .with(headers: request_headers)
    #  .to_return(body: File.read("spec/fixtures/chat.json"))

    it "should send a chat and receive a streaming completion response" do
      OpenAI::Client.new.chat("gpt-3.5-turbo", [
        {role: "user", content: "What are the steps to create a new rails application?"},
      ], {"stream" => true}) do |chunk|
        puts chunk.choices.first.delta
      end
    end

    it "should accept functions" do
      list_cats = OpenAI.def_function("list_cats", "A list of cat names", CatNameResponse)

      client = OpenAI::Client.new

      response = client.chat("gpt-3.5-turbo-0613", [
        {role: "user", content: "Give me a list of names for my cat."},
      ], {"functions" => [list_cats]})

      pp response
      pp CatNameResponse.from_json(response.result(0))
    end

    it "should accept functions for the streaming API" do
      list_cats = OpenAI.def_function("list_cats", "A list of cat names", CatNameResponse)

      client = OpenAI::Client.new

      output = ""
      client.chat("gpt-3.5-turbo-0613", [
        {role: "user", content: "Give me a list of 30 names for a cat."},
      ], {"stream" => true, "functions" => [list_cats]}) do |chunk|
        if function_call = chunk.choices.first.delta.function_call
          output += function_call.arguments

          pp function_call.arguments
        end
      end

      pp CatNameResponse.from_json(output)
    end

    it "should chat without functions" do
      client = OpenAI::Client.new

      response = client.chat("gpt-3.5-turbo", [{role: "user", content: "Give me a list of names for my cat."}])
      
      pp response
    end

    it "should chat with the streaming API without functions being provided" do
      client = OpenAI::Client.new

      output = ""
      client.chat("gpt-3.5-turbo", [
        {role: "user", content: "Give me 30 cat names as a comma separated list"},
      ], {"stream" => true}) do |chunk| 
        output += chunk.to_json.to_s
      end

      pp output
    end
  end
end
