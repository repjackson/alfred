if Meteor.isClient
    Template.full_view.onCreated ->
        @autorun => @subscribe 'model_docs','ai_comment', ->
    
    Template.field_template.helpers 
        field_value: ->
            doc = Docs.findOne Session.get('fullview_id')
            doc["#{@valueOf()}"]
    Template.full_view.helpers 
        doc_fields: ->
            _.keys(@)
        this_value: ->
            doc = Docs.findOne Session.get('fullview_id')
            doc["#{@valueOf()}"]
    Template.full_view.events
        'keyup .ai_input2': (e,t)->
            # query = $('.search_site').val()
            input = t.$('.ai_input2').val()
            if e.which is 13
                $(e.currentTarget).closest('.ai_input').transition('pulse', 100)
                Meteor.call 'ai_comment', input, Session.get('fullview_id'),->
                # Session.set('current_query', search)
                $('.ai_input').val('')
                # $('body').toast({title: "submitting: #{search}"})
    
        'click .publish': -> 
            if confirm 'publish?'
                Docs.update @_id, 
                    $set:
                        publish_status:'published'
                        published:true
                        published_timestamp:Date.now()
        'click .edit_this': -> Session.set('editing',true)
        'click .save_this': -> Session.set('editing',false)
        'keyup .add_tag': (e,t)->
            if e.which is 13 
                tag = $('.add_tag').val()
                if tag.length > 1
                    Docs.update @_id, 
                        $addToSet:tags:tag
                    tag = $('.add_tag').val('')
        'blur .add_tag': (e,t)->
            tag = $('.add_tag').val()
            if tag.length > 1
                Docs.update @_id, 
                    $addToSet:tags:tag
                tag = $('.add_tag').val('')
