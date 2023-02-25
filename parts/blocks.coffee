if Meteor.isClient
    Template.comments.onRendered ->
        # Meteor.setTimeout ->
        #     $('.accordion').accordion()
        # , 1000
    Template.comments.onCreated ->
        parent = Template.currentData()
        if parent
            @autorun => Meteor.subscribe 'children', 'comment', parent._id, ->
    Template.comments.helpers
        doc_comments: ->
            # this should all just be @_id but i guess works for now
            if @_id
                parent = Docs.findOne @_id
            else if Template.parentData()
                parent = Docs.findOne Template.parentData()._id
            if parent
                Docs.find {
                    # parent_id:parent._id
                    parent_ids:$in:[parent._id]
                    model:'comment'
                }, sort:_timestamp:-1
    Template.comments.events
        'keyup .add_comment': (e,t)->
            if e.which is 13
                parent = Template.currentData()
                comment = t.$('.add_comment').val()
                Docs.insert
                    parent_id: parent._id
                    parent_ids:[parent._id]
                    model:'comment'
                    parent_model:parent.model
                    body:comment
                t.$('.add_comment').val('')
                t.$('.add_comment').transition('bounce', 1000)


        'click .remove_comment': ->
            if confirm 'Confirm remove comment'
                Docs.remove @_idif Meteor.isClient
                
                
    Template.replys.onRendered ->
        # Meteor.setTimeout ->
        #     $('.accordion').accordion()
        # , 1000
    Template.replys.onCreated ->
        @autorun => Meteor.subscribe 'children', 'reply', Template.parentData()._id, ->
    Template.replys.helpers
        doc_replys: ->
            # this should all just be @_id but i guess works for now
            if @_id
                parent = Docs.findOne @_id
            else if Template.parentData()
                parent = Docs.findOne Template.parentData()._id
            if parent
                Docs.find {
                    # parent_id:parent._id
                    parent_ids:$in:[parent._id]
                    model:'reply'
                }, sort:_timestamp:-1
    Template.replys.events
        'keyup .add_reply': (e,t)->
            # console.log Template.parentData(1)
            # console.log Template.parentData(2).data.data
            # console.log Template.parentData(3)
            if e.which is 13
                parent = Template.parentData(2).data.data
                reply = t.$('.add_reply').val()
                Docs.insert
                    parent_id: parent._id
                    parent_ids:[parent._id]
                    model:'reply'
                    parent_model:parent.model
                    body:reply
                t.$('.add_reply').val('')
                t.$('.add_reply').transition('bounce', 1000)


        'click .remove_reply': ->
            if confirm 'Confirm remove reply'
                Docs.remove @_id
if Meteor.isServer
    Meteor.publish 'children', (model, parent_id, limit)->
        # console.log model
        # console.log parent_id
        limit = if limit then limit else 10
        Docs.find {
            model:model
            # parent_id:parent_id
            parent_ids:$in:[parent_id]
        }, limit:limit
