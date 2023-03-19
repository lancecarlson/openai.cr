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

  record ChatResponse, id : String, object : String, created : Int32, model : String, usage : CompletionUsage, choices : Array(NamedTuple(message: NamedTuple(role: String, content: String), finish_reason: String, index: Int32)) do
    include JSON::Serializable
  end

  record CompletionsResponse, id : String, object : String, created : Int32, model : String, usage : CompletionUsage, choices : Array(NamedTuple(text: String, index: Int32, logprobs: Int32 | Nil, finish_reason: String)) do
    include JSON::Serializable
  end

  record Embedding, object : String, index : Int32, embedding : Array(Float64) do
    include JSON::Serializable
  end

  record EmbeddingsResponse, object : String, data : Array(Embedding), model : String, usage : Usage do
    include JSON::Serializable
  end
end
