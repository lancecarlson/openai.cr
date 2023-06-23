# OpenAI

Client library for Open AI built in crystal lang. 

Note: This is a community maintained library.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     openai:
       github: lancecarlson/openai.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "openai"

openai = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

# List and show models
openai.models.list
openai.models.retrieve("davinci")

# Creates a completion for the chat message
openai.chat("gpt-3.5-turbo", [
  {role: "user", content: "Hi!"},
])

# Function support
class CatNameResponse
  include JSON::Serializable

  @[JSON::Field(description: "A name of a cat")]
  getter cats : Array(String)
end

list_cats = OpenAI.def_function("list_cats", "A list of cat names", CatNameResponse)

client = OpenAI::Client.new

response = client.chat("gpt-3.5-turbo-0613", [
  {role: "user", content: "Give me a list of names for my cat."},
], {"functions" => [list_cats]})

pp response
pp CatNameResponse.from_json(response.result(0))

# Streaming
openai.chat("gpt-3.5-turbo", [
  {role: "user", content: "Hi!"},
], {"stream" => true}) do |chunk|
  pp chunk.choices.first.delta
end

# Function Support
class CatNameResponse
  include JSON::Serializable

  @[JSON::Field(description: "A name of a cat")]
  getter cats : Array(String)
end

list_cats = OpenAI.def_function("list_cats", "A list of cat names", CatNameResponse)

client = OpenAI::Client.new

output = ""
client.chat("gpt-3.5-turbo-0613", [
  {role: "user", content: "Give me a list of 30 names for a cat."},
], {"stream" => true, "functions" => [list_cats]}) do |chunk|
  if function_call = chunk.choices.first.delta.function_call
    output += function_call.arguments

    pp function_call.arguments
  end
end

pp CatNameResponse.from_json(output)

# Creates a completion for the provided prompt and parameters
openai.completions("text-davinci-003", "Hi!", {
  temperature: 0.5
})

# Creates a new edit for the provided input, instruction, and parameters.
openai.edits(
  "text-davinci-edit-001",
  "What day of the wek is it?",
  "Fix the spelling mistakes"
)

# Creates an embedding vector representing the input text.
openai.embeddings("text-embedding-ada-002", "Hello world!")

# Classifies if text violates OpenAI's Content Policy
openai.moderations("I want to kill them.")
```

Some endpoints are still under active development. I could use help if you want to send a PR for them!
* Audio endponts (transcriptions and translations)
* Files/Images/Fine Tunes

## Development

The specs use webmock. You can comment them out to run a real request using your own Open AI API key.
I tried to make the requests use as few tokens as possible. If you plan on updating or adding an endpoint,
it's usually easiest if you copy the response from the Open AI API docs and stick it in the fixtures folder.
From there, build out a response struct inside of responses.cr and the rest should be fairly straight forward
with the client endpoints. If a resource has multiple endpoints like models or audio, it might be a good idea
to stick them in their own file for better organization.

At some point I want to get deeper into the error messages and handle these better as well.

## Contributing

1. Fork it (<https://github.com/lancecarlson/openai/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lance Carlson](https://github.com/lancecarlson) - creator and maintainer
