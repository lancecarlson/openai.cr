require "./spec_helper"

describe OpenAI do
  describe "chat" do
    WebMock.stub(:post, "https://api.openai.com/v1/completions")
      .with(headers: request_headers)
      .to_return(body: File.read("spec/fixtures/completions.json"))

    it "should send a basic completions request" do
      pp OpenAI::Client.new.completions("text-davinci-003", "Hi!")
    end
  end
end
