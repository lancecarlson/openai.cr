require "./spec_helper"

describe OpenAI do
  describe "moderations" do
    # WebMock.stub(:post, "https://api.openai.com/v1/moderations")
    #  .with(headers: request_headers)
    #  .to_return(body: File.read("spec/fixtures/moderations.json"))

    it "classifies if text violates OpenAI's Content Policy" do
      pp OpenAI::Client.new.moderations("I want to kill them.")
    end
  end
end
