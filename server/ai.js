const { Configuration, OpenAIApi } = require("openai");
Meteor.methods({
    ai: async function(input,parent_id=null) {
        const configuration = new Configuration({
            apiKey: Meteor.settings.private.openai2,
        });
        const openai = new OpenAIApi(configuration);
        prompt = input
        if (parent_id) {
            parent = Docs.findOne(parent_id)
            prompt = input + parent.body
        } 
        console.log('searching ai for:',input)
        var has_add
        has_add = input.includes('add') || input.includes('create')
        if (has_add) {
            console.log('has add')
            prompt = 'json format without comments'+input 
        }
        
        const response = await openai.createCompletion({
            // model: "code-davinci-002",
            // model: "gpt-3.5-turbo",
            model: "text-davinci-003",
            //   prompt: "Decide whether a Tweet's sentiment is positive, neutral, or negative.\n\nTweet: \"I loved the new Batman movie!\"\nSentiment:",
            //   prompt: "create a description for a dance event at the Riverside in Boulder Colorado ",
                // prompt: input
            // prompt: "using this schema: 'id: string, eventName: String, eventDescription: String, eventLocation: Point', generate graphql queries and mutations that do this:" + parent,
            prompt: prompt,

            //   prompt: "create a schema.org schema for the following event: 'Come join us for a night of dancing at the Riverside in Boulder, Colorado! Enjoy the beautiful views of the river and the Rocky Mountains while you dance to your favorite tunes. Our DJ will be spinning all your favorite hits from the 70s, 80s, 90s, and today'",
            temperature: 0,
            max_tokens: 1000,
            top_p: 1,
            frequency_penalty: 0.5,
            presence_penalty: 0,
        });
        console.log('response, calling create',response.data)
        Meteor.call('create_ai_doc',response.data, input)
        },
    // parse: async function(input,parent_id) {
    //     const configuration = new Configuration({
    //         apiKey: Meteor.settings.private.openai2,
    //     });
    //     const openai = new OpenAIApi(configuration);
    //     if (parent_id) {
    //         parent = Docs.findOne(parent_id)
    //         // if (parent) {
    //             // console.log('parsing', parent)
    //         // }
    //         // prompt = input + parent.body
        
    //         const response = await openai.createCompletion({
    //             model: "text-davinci-003",
    //             // prompt:"create a list of keywords as an array of strings in json for: " + parent.body,
    //             // prompt:"create a mongo document schema for: " + parent.body,
    //             // prompt:"create a meteor.js database update call in javascript that updates field values for: " + parent.body,
                
    //             prompt: "using this schema: 'id: string, eventName: String, eventDescription: String, eventLocation: Point', generate graphql queries and mutations that do this:" + parent,
                
    //             // prompt:"write mongodb meteor coffeescript code that updates the title of this document to 'oracle2' " + parent,
    //             // prompt: input + parent.body,
    //             temperature: 0,
    //             max_tokens: 100,
    //             top_p: 1,
    //             frequency_penalty: 0.5,
    //             presence_penalty: 0,
    //         });
    //         a = response.data.choices[0].text
    //         command = (a.substring(a.indexOf("set:"), a.lastIndexOf('}}') + 1));
    //         // command 
    //         // stripped = 
    //         stripped = (command.substring(command.indexOf("{"), command.indexOf("}") + 1));
            
    //         console.log('stripped', stripped)
    //         key = (stripped.substring(stripped.indexOf("{")+1, stripped.indexOf(":")));
            
    //         value = (stripped.substring(stripped.indexOf(":")+3, stripped.indexOf("}")-1));
            
    //         console.log('key', key)
    //         console.log('value', value)
    //         Meteor.call('ai_update_field',key,value, parent_id)
    //         } 
    //     },
    ai_comment: async function(input,parent_id) {
        const configuration = new Configuration({
            apiKey: Meteor.settings.private.openai2,
        });
        const openai = new OpenAIApi(configuration);
        if (parent_id) {
            parent = Docs.findOne(parent_id)
            // if (parent) {
                // console.log('parsing', parent)
            // }
            // prompt = input + parent.body
            console.log('input',input,'parent body',parent.body)
            const response = await openai.createCompletion({
                model: "text-davinci-003",
                // prompt:"create a list of keywords as an array of strings in json for: " + parent.body,
                // prompt:"create a mongo document schema for: " + parent.body,
                // prompt:"create a meteor.js database update call in javascript that updates field values for: " + parent.body,
                // prompt:"write mongodb meteor coffeescript code that updates the title of this document to 'oracle2' " + parent,
                prompt: 'using this schema: (id: ID!, name: String, description: String, website: String, email: String, phone: String, address: String, city: String, state: String, zip: String, country: String, logoUrl: String, bannerUrl: String), generate meteor calls that do this:' + input + parent.body,
                    // generate graphql queries and mutations that do this:' + input,
                temperature: 0,
                max_tokens: 100,
                top_p: 1,
                frequency_penalty: 0.5,
                presence_penalty: 0,
            });
            response_text = response.data.choices[0].text
            Meteor.call('add_ai_comment',input,response_text,parent_id)
            } 
        }
})