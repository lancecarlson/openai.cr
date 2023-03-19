require "./spec_helper"

describe OpenAI do
  describe "chat" do
    WebMock.stub(:post, "https://api.openai.com/v1/edits")
      .with(headers: request_headers)
      .to_return(body: File.read("spec/fixtures/edits.json"))

    it "creates a new edit for the provided input, instruction, and parameters." do
      OpenAI::Client.new.edits(
        "text-davinci-edit-001",
        "What day of the wek is it?",
        "Fix the spelling mistakes"
      )
    end
  end
end
