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
  end
end
