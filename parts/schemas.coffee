@schemas =
    name:'schemas mothafucka!'
    models:
        tasks:
            name:'Tasks'
            slug:'task'
            parent_models:['post']
            fields: [
                name:'title'
                timer_start:
                    field_type:'datetime'
                    template:'timer'
                    on_change: ->
                        console.log @
                        # ginsert 'shift'
                        # Docs.insert 
                        #     model:'shift'
                timer_stop:
                    field_type:'array'
                    array_element_type:'datetime'
                timer_duration:
                    field_type:'int'
                    auto_value:true
                timer_paused:
                    field_type:'boolean'
                timer_paused_timestamp:
                    field_type:'datetime'
                completed:
                    field_type:'boolean'
                    on_change: ->
                        alert 'changed'
                        # gcall 'complete_task', ->
            ]
            viewing_roles:['admin','author']
            edit_roles:['admin','author','owner','holder']
            point_view_cost:'number'
            can_edit: ->
                console.log @
                Meteor.user().roles in @edit_roles
            attendees:'user_picker'
            field_list:['title','author', ]
        events:
            name:'Events'
            slug:'event'
            parent_models:['post']
            fields: [
                {
                    name:'title'
                    type:'text'
                    index:1
                    icon:'header'
                    can_edit: ->
                        Meteor.userId()
                }
            ]
            viewing_roles:['admin','author']
            point_view_cost:'number'
            attendees:'user_picker'
            list_all: ->
                console.log @
                Docs.find 
                    model:'ai'
            field_list:['title','author', ]
        posts:
            name:'Posts'
            parent_models:['Thing']
            fields:
                title:
                    field_type:'text'
                    icon:'header'
                creator:
                    field_type:'user'
                    icon:'user'
                owner:
                    field_type:'user'
                    icon:'user'
                holder:
                    field_type:'user'
                    icon:'user'
        product:
            slug:'product'
        service:
            slug:'service'
        offer:
            slug:'offer'
        request:
            slug:'request'
        role:
            slug:'role'
        resources:
            slug:'resource'
        skills:
            slug:'skill'
        badge:
            slug:'badge'
        org:
            slug:'org'
        group:
            slug:'group'
        project:
            slug:'project'
    field_types:
        list:['text','datetime','boolean','latlong']
    methods: 
        complete_task: ->
            Docs.update @_id, 
                $set:
                    completed:true
            # notify user 
            # tranfer coin
        tranfer_coin: (target, source, parent)->
            # create new alert 
            # check balences
            # send sms
    permissions:
        admin:'admin'
        owner:
            value: ->
                Meteor.userId() in context.roles
                'owner' in Meteor.user().roles 
