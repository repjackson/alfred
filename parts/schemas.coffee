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
            point_view_cost:'number'
            attendees:'user_picker'
            field_list:['title','author', ]
        events:
            name:'Events'
            parent_models:['post']
            fields: [
                name:'title'
                # title: {
                #     field_type:'text'
                #     icon:'header'
                # }
            viewing_roles:['admin','author']
            point_view_cost:'number'
            attendees:'user_picker'
            list_all: ->
                Docs.find 
                    model:'event'
            field_list:['title','author', ]
            ]
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
    field_types: []
    methods: 
        complete_task: ->
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
