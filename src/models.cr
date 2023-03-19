module OpenAI
  record ModelPermission, id : String, object : String, created : Int32, allow_create_engine : Bool, allow_sampling : Bool, allow_logprobs : Bool, allow_search_indices : Bool, allow_view : Bool, allow_fine_tuning : Bool, organization : String, group : String | Nil, is_blocking : Bool do
    include JSON::Serializable
  end
  record Model, id : String, object : String, created : Int32, owned_by : String, permission : Array(ModelPermission), root : String, parent : String | Nil do
    include JSON::Serializable
  end
  record ModelResponse, object : String, data : Array(Model) do
    include JSON::Serializable
  end

  class Models
    def initialize(client : Client)
      @client = client
    end

    def list
      ModelResponse.from_json(@client.get(path: "/models"))
    end

    def retrieve(id : String)
      Model.from_json(@client.get(path: "/models/#{id}"))
    end
  end
end
