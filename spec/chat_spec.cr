require "./spec_helper"

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
