module OpenAI
  # Response objects
  record ListResponse, object : String, data : Array(Model) do
    include JSON::Serializable
  end

  record Usage, prompt_tokens : Int32, total_tokens : Int32 do
    include JSON::Serializable
  end

  record CompletionUsage, prompt_tokens : Int32, total_tokens : Int32, completion_tokens : Int32 do
    include JSON::Serializable
  end

  record FunctionCall, name : String | Nil, arguments : String do
    include JSON::Serializable

    def from_json(type)
      type.from_json(arguments)
    end
  end

  record ChatResponse, id : String, object : String, created : Int32, model : String, usage : CompletionUsage, choices : Array(NamedTuple(message: NamedTuple(role: String, content: String), finish_reason: String, index: Int32)) do
    include JSON::Serializable

    def result(index : Int32)
      message = choices[index][:message]
      message[:content]
    end
  end

  record ChatFunctionResponse, id : String, object : String, created : Int32, model : String, usage : CompletionUsage, choices : Array(NamedTuple(message: NamedTuple(role: String, content: String | Nil, function_call: FunctionCall), finish_reason: String, index: Int32)) do
    include JSON::Serializable

    def result(index : Int32)
      message = choices[index][:message]
      message[:function_call].arguments
    end
  end

  record Delta, role : String | Nil, content : String | Nil, function_call : FunctionCall | Nil do
    include JSON::Serializable
  end

  record Choice, delta : Delta, index : Int32, finish_reason : String | Nil do
    include JSON::Serializable
  end

  record CompletionChunk, id : String, object : String, created : Int32, model : String, choices : Array(Choice) do
    include JSON::Serializable
  end

  record CompletionsResponse, id : String, object : String, created : Int32, model : String, usage : CompletionUsage, choices : Array(NamedTuple(text: String, index: Int32, logprobs: Int32 | Nil, finish_reason: String)) do
    include JSON::Serializable
  end

  record EditsResponse, object : String, created : Int32, usage : CompletionUsage, choices : Array(NamedTuple(text: String, index: Int32)) do
    include JSON::Serializable
  end

  record Embedding, object : String, index : Int32, embedding : Array(Float64) do
    include JSON::Serializable
  end

  record EmbeddingsResponse, object : String, data : Array(Embedding), model : String, usage : Usage do
    include JSON::Serializable
  end

  record ModerationsResponse, id : String, model : String, results : Array(NamedTuple(categories: Hash(String, Bool), category_scores: Hash(String, Float64), flagged: Bool)) do
    include JSON::Serializable
  end

  record TranscriptionsResponse, text : String do
    include JSON::Serializable
  end
end
