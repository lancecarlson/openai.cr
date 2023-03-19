require "./spec_helper"

describe OpenAI do
  describe OpenAI::Models do
    describe "list" do
      WebMock.stub(:get, "https://api.openai.com/v1/models")
        .with(headers: request_headers)
        .to_return(body: File.read("spec/fixtures/models.json"))

      it "returns a list of models" do
        OpenAI::Client.new.models.list
      end
    end

    describe "retrieve" do
      # WebMock.stub(:get, "https://api.openai.com/v1/models/davinci")
      #  .with(headers: request_headers)
      #  .to_return(body: File.read("spec/fixtures/model.json"))

      it "returns a model" do
        OpenAI::Client.new.models.retrieve("davinci")
      end
    end
  end
end
