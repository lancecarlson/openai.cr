require "./spec_helper"

describe OpenAI do
  describe "embeddings" do
    WebMock.stub(:post, "https://api.openai.com/v1/embeddings")
      .with(headers: request_headers)
      .to_return(body: File.read("spec/fixtures/embeddings.json"))

    it "should create embeddings" do
      OpenAI::Client.new.embeddings("babbage-similarity", "Hello world!")
    end
  end
end
