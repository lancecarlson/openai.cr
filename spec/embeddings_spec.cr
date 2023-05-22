require "./spec_helper"

describe OpenAI do
  describe "embeddings" do
    WebMock.stub(:post, "https://api.openai.com/v1/embeddings")
      .with(headers: request_headers)
      .to_return(body: File.read("spec/fixtures/embeddings.json"))

    it "should create embeddings" do
      OpenAI::Client.new.embeddings("babbage-similarity", "Hello world!")
    end

    # it "should raise an exception if we've hit the maximum context length" do
    #  expect_raises(OpenAI::Error::InvalidRequestError) do
    #    OpenAI::Client.new.embeddings("babbage-similarity", "aaaa" * 10001)
    #  end
    # end
  end
end
