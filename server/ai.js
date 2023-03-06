const { Configuration, OpenAIApi } = require("openai");
Meteor.methods({
  ai: async function(input) {
    const configuration = new Configuration({
      apiKey: Meteor.settings.private.openai2,
    });
    const openai = new OpenAIApi(configuration);
    
    const response = await openai.createCompletion({
        model: "text-davinci-003",
        //   prompt: "Decide whether a Tweet's sentiment is positive, neutral, or negative.\n\nTweet: \"I loved the new Batman movie!\"\nSentiment:",
        //   prompt: "create a description for a dance event at the Riverside in Boulder Colorado ",
        prompt:input,
        //   prompt: "create a schema.org schema for the following event: 'Come join us for a night of dancing at the Riverside in Boulder, Colorado! Enjoy the beautiful views of the river and the Rocky Mountains while you dance to your favorite tunes. Our DJ will be spinning all your favorite hits from the 70s, 80s, 90s, and today'",
        temperature: 0,
        max_tokens: 60,
        top_p: 1,
        frequency_penalty: 0.5,
  presence_penalty: 0,
    });
    console.log(response.data)
    Meteor.call('create_ai_doc',response.data)
    }
})