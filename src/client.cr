module OpenAI
  class Client
    class ClientError < Exception
    end

    URI_BASE = "https://api.openai.com/"

    def initialize(access_token : String | Nil = nil, organization_id : String | Nil = nil)
      OpenAI.configuration.access_token = access_token if access_token
      OpenAI.configuration.organization_id = organization_id if organization_id
    end

    def chat(model : String, messages : Array(NamedTuple(role: String, content: String)), options : Hash | Nil = nil)
      parameters = {
        "model"    => model,
        "messages" => messages,
      }
      parameters = parameters.merge(options) if options
      ChatResponse.from_json(post(path: "/chat/completions", parameters: parameters))
    end

    def completions(model : String, prompt : String, options : Hash | Nil = nil)
      parameters = {
        "model"  => model,
        "prompt" => prompt,
      }
      parameters = parameters.merge(options) if options
      CompletionsResponse.from_json(post(path: "/completions", parameters: parameters))
    end

    # def completions(parameters : JSON::Any = {})
    #  self.class.json_post(path: "/completions", parameters: parameters)
    # end

    # def edits(parameters : JSON::Any = {})
    #  self.class.json_post(path: "/edits", parameters: parameters)
    # end

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

    # def moderations(parameters : JSON::Any = {})
    #  self.class.json_post(path: "/moderations", parameters: parameters)
    # end

    # def transcribe(parameters : JSON::Any = {})
    #  self.class.multipart_post(path: "/audio/transcriptions", parameters: parameters)
    # end

    # def translate(parameters : JSON::Any = {})
    #  self.class.multipart_post(path: "/audio/translations", parameters: parameters)
    # end

    def get(path : String)
      response = client.get("/v1" + path, headers: headers)
      handle_response(response)
    end

    def post(path : String, parameters : Hash)
      response = client.post("/v1" + path, headers: headers, body: parameters.to_json)
      handle_response(response)
    end

    # def self.multipart_post(path : String, parameters : Hash(String, String)?)
    #  response = HTTP::Client.post(concat_path(path), headers: headers.merge({"Content-Type" => "multipart/form-data"}), form: parameters)
    #  response.body.to_s
    # end

    # def self.delete(path : String)
    #  response = HTTP::Client.delete(concat_path(path), headers: headers)
    #  response.body.to_s
    # end

    private def client
      @client ||= HTTP::Client.new(URI.parse(URI_BASE))
    end

    private def handle_response(response) : String
      puts response.body.to_s
      if response.success?
        response.body.to_s
      else
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
