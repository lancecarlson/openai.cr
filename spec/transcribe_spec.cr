require "./spec_helper"

describe OpenAI do
  describe "transcribe" do
    WebMock.stub(:post, "https://api.openai.com/v1/audio/transcriptions")
      .with(headers: request_headers)
      .to_return(body: File.read("spec/fixtures/transcriptions.json"))

    it "transcribes audio into the input language." do
      # TODO: implement this
      # OpenAI::Client.new.transcribe("audio.mp3")
    end
  end
end
