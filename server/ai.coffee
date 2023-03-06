# gpt3 = require 'openai-api'
# response = gpt3.query {
#   prompt: "I loved the new Batman movie!",
#   sentiment: "positive"
# }

# # import { Configuration, OpenAIApi } from "openai"


# # Meteor.methods 
# #     ai: ->
# #         configuration = new Configuration({
# #             apiKey: Meteor.settings.openai2,
# #         # });
# #         openai = new OpenAIApi(configuration);
        
# #         response = await openai.createCompletion({
# #           model: "text-davinci-003",
# #           prompt: "Decide whether a Tweet's sentiment is positive, neutral, or negative.\n\nTweet: \"I loved the new Batman movie!\"\nSentiment:",
# #           temperature: 0,
# #           max_tokens: 60,
# #           top_p: 1,
# #           frequency_penalty: 0.5,
# #           presence_penalty: 0,
# #         });
# #         console.log response