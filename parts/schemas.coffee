@schemas =
    models:
        task:
            name:'Task'
            slug:'task'
            parent_models:['post', 'thing']
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
        event:
            name:'Event'
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
        post:
            name:'Post'
            parent_models:['Thing']
            _is_author:->
                Meteor.userId() is @_author_id
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
                    required:true
                    can_edit: -> @_is_author
                holder:
                    field_type:'user'
                    icon:'user'
                published:
                    type:'boolean'
                    on_change: ->
                        if @published
                            Docs.update @_id,   
                                publish_timestamp:Date.now()
                            Meteor.call 'mint_one_coin', @_author_id, Meteor.userId(), @_id, ->
        ai:             
            slug:'ai'
            fields:[
                {
                    title:'title'
                }
                {
                    title:'body'
                }
            ]
        product:
            name:'Product'
            slug:'product'
        service:
            name:'Service'
            slug:'service'
        offer:
            name:'Offer'
            slug:'offer'
        request:
            name:'Request'
            slug:'request'
        role:
            name:'Role'
            slug:'role'
        resource:
            name:'Resource'
            slug:'resource'
        skills:
            name:'Skills'
            slug:'skill'
        badge:
            name:'Badge'
            slug:'badge'
        org:
            name:'Org'
            slug:'org'
            subtype:
                type:'string'
                template:'list_picker'
                allowed_values:@subtypes
            subtypes:
                type:'doc_ref'
                ref_model:'org_subtype'
                # ['event production company','event venue']
            # subtype_ref:schemas.models.org_subtype
        group:
            name:'Group'
            slug:'group'
        project:
            name:'Project'
            slug:'project'
        
    field_types:
        list:['text','datetime','boolean','latlong']
    hooks:
        before: ->
            doc = {}
            if Meteor.userId()
                doc._author_id = Meteor.userId()
                doc._author_username = Meteor.user().username
            timestamp = Date.now()
            doc._timestamp = timestamp
            doc._timestamp_long = moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
            date = moment(timestamp).format('Do')
            weekdaynum = moment(timestamp).isoWeekday()
            weekday = moment().isoWeekday(weekdaynum).format('dddd')
        
            hour = moment(timestamp).format('h')
            minute = moment(timestamp).format('m')
            ap = moment(timestamp).format('a')
            month = moment(timestamp).format('MMMM')
            year = moment(timestamp).format('YYYY')
        
            # date_array = [ap, "hour #{hour}", "min #{minute}", weekday, month, date, year]
            date_array = [ap, weekday, month, date, year]
            if _
                date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
                # date_array = _.each(date_array, (el)-> console.log(typeof el))
                # console.log date_array
                doc._timestamp_tags = date_array
            Docs.update @_id, 
                $set:
                    _author_id:Meteor.userId()
                    _author_username:Meteor.user().username
                    _timestamp:Date.now()
 
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
