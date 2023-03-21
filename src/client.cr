module OpenAI
  class Client
    class ClientError < Exception
    end

    URI_BASE = "https://api.openai.com/"

    def initialize(access_token : String | Nil = nil, organization_id : String | Nil = nil)
      OpenAI.configuration.access_token = access_token if access_token
      OpenAI.configuration.organization_id = organization_id if organization_id
    end

    def chat(model : String, messages : Array(NamedTuple(role: String, content: String)), options : Hash | NamedTuple | Nil = nil)
      parameters = {
        "model"    => model,
        "messages" => messages,
      }
      parameters = parameters.merge(options) if options
      ChatResponse.from_json(post(path: "/chat/completions", parameters: parameters))
    end

    def completions(model : String, prompt : String, options : Hash | NamedTuple | Nil = nil)
      parameters = {
        "model"  => model,
        "prompt" => prompt,
      }
      parameters = parameters.merge(options.to_h) if options
      CompletionsResponse.from_json(post(path: "/completions", parameters: parameters))
    end

    def edits(model : String, input : String, instruction : String, options : Hash | NamedTuple | Nil = nil)
      parameters = {
        "model"       => model,
        "input"       => input,
        "instruction" => instruction,
      }
      parameters = parameters.merge(options.to_h) if options
      EditsResponse.from_json(post(path: "/edits", parameters: parameters))
    end

    def embeddings(model : String, input : String, user : String | Nil = nil)
      parameters = {
        "model" => model,
        "input" => input,
      }
      parameters["user"] = user if user
      EmbeddingsResponse.from_json(post("/embeddings", parameters))
    end

    # def files
    #  @files ||= OpenAI::Files.new
    # end

    # def finetunes
    #  @finetunes ||= OpenAI::Finetunes.new
    # end

    # def images
    #  @images ||= OpenAI::Images.new
    # end

    def models
      @models ||= OpenAI::Models.new(self)
    end

    def moderations(input : String | Array(String), model : String = "text-moderation-latest")
      parameters = {
        "input" => input,
        "model" => model,
      }
      ModerationsResponse.from_json(post(path: "/moderations", parameters: parameters))
    end

    # TODO: This is not working, multipart_post is not working
    # def transcribe(file : String, model : String = "whisper-1", options : Hash | Nil = nil)
    #  parameters = {
    #    "file"  => file,
    #    "model" => model,
    #  }
    #  parameters = parameters.merge(options) if options
    #  TranscriptionsResponse.from_json(multipart_post(path: "/audio/transcriptions", parameters: parameters))
    # end

    # def translate
    # end

    def get(path : String)
      response = client.get("/v1" + path, headers: headers)
      handle_response(response)
    end

    def post(path : String, parameters : Hash)
      response = client.post("/v1" + path, headers: headers, body: parameters.to_json)
      handle_response(response)
    end

    # TODO: This is not working, need to look at https://crystal-lang.org/api/1.7.3/HTTP/FormData.html
    def multipart_post(path : String, parameters : Hash)
      headers["Content-Type"] = "multipart/form-data"
      response = client.post("/v1" + path, headers: headers, form: parameters.to_json)
      handle_response(response)
    end

    # def delete(path : String)
    #  response = client.delete("/v1" + path, headers: headers)
    #  handle_response(response)
    # end

    private def client
      @client ||= HTTP::Client.new(URI.parse(URI_BASE))
    end

    private def handle_response(response) : String
      if response.success?
        response.body.to_s
      else
        # TODO: Parse the error message better
        # Example:
        # "{\n" +
        # "  \"error\": {\n" +
        # "    \"message\": \"1 validation error for Request\\nbody -> input\\n  field required (type=value_error.missing)\",\n" +
        # "    \"type\": \"invalid_request_error\",\n" +
        # "    \"param\": null,\n" +
        # "    \"code\": null\n" +
        # "  }\n" +
        # "}"
        error = JSON.parse(response.body)
        raise ClientError.new(error["error"]["message"].to_s)
      end
    end

    private def headers
      headers = HTTP::Headers{
        "Content-Type"  => "application/json",
        "Authorization" => "Bearer #{OpenAI.configuration.access_token}",
      }
      if organization_id = OpenAI.configuration.organization_id
        headers["OpenAI-Organization"] = organization_id
      end
      headers
    end
  end
end
