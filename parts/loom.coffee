@Docs = new Meteor.Collection 'docs'
@Results = new Meteor.Collection 'results'

Docs.before.insert (userId, doc)->
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

    # doc.app = 'nf'
    # doc.points = 0
    # doc.downvoters = []
    # doc.upvoters = []
    return
if Meteor.isClient 
    moment.locale('en', {
        relativeTime: {
            future: 'in %s',
            # past: '%s ago',
            past: '%s',
            s:  'seconds',
            ss: '%ss',
            m:  'a minute',
            mm: '%dm',
            h:  'an hour',
            hh: '%dh',
            d:  'a day',
            dd: '%dd',
            M:  'a month',
            MM: '%dM',
            y:  'a year',
            yy: '%dY'
        }
    });
    
    Router.route '/', (->
        @layout 'layout'
        @render 'loom'
        ), name:'loom'    
    
    Template.registerHelper 'field_value', () -> 
        # console.log @
        parent = Template.parentData()
        parent["#{@key}"]
    Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
    Template.registerHelper 'from_now', (input) -> moment(input).fromNow()
    Template.registerHelper 'model_docs', (model) -> 
    
    Template.registerHelper 'schemas', (key) -> schemas
    # Meteor.isClient && Template.registerHelper("Schemas", Schemas);

    Template.registerHelper 'session_get', (key) -> Session.get("#{key}")
    Template.registerHelper 'model_docs_helper', (model) ->
        Docs.find 
            model:model
    Template.registerHelper 'picked_tags', ()-> picked_tags.array()
        
    Template.registerHelper '_is', (key,value)-> @["#{key}"] is value
    
    Template.registerHelper 'parent_schema', ()->
        Docs.findOne 
            model:'schema'
            'rdfs:label':@model
    Template.registerHelper 'can_edit', ()->
        console.log 'can edit?',@
    # this is the field 
        current_model = Router.current().params.model
        field = @
        @can_edit
    Template.registerHelper 'nl2br', (text)->
        nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
        new Spacebars.SafeString(nl2br)

    # Template.datepicker.onRendered ->
    #     Session.setDefault('view_calendar',true)
    #     @picker = new easepick.create({
    #         element: "#datepicker",
    #         css: [
    #             "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css"
    #         ],
    #         zIndex: 10,
    #         plugins: [
    #             "RangePlugin"
    #         ]
    #         inline: true
    #     })
    #     # console.log @picker
    #     # $('#rangestart').calendar({
    #     #   type: 'date',
    #     #   today:true,
    #     # #   endCalendar: $('#rangeend')
    #     # });
    #     # $('#rangeend').calendar({
    #     #   type: 'date',
    #     #   startCalendar: $('#rangestart')
    #     # });
    Template.session_toggle.events 
        'click .toggle': ->
            # console.log Session.get("#{@key}"), @key
            Session.set("#{@key}", !Session.get("#{@key}"))
    Template.filter_model.events 
        'click .pick_model': -> picked_tags.push @model
    Template.voting.events
        'click .upvote': (e,t)->
            $(e.currentTarget).closest('.button').transition('pulse',500)
            Meteor.call 'upvote', @, ->
        'click .downvote': (e,t)->
            $(e.currentTarget).closest('.button').transition('pulse',500)
            Meteor.call 'downvote', @, ->


 
    Template.eft_filter.events 
        'click .pick_eft': -> picked_tags.push @label.toLowerCase()
    # Template.datepicker.events 
    #     'click .get': (e,t)-> 
    #         console.log t.picker.getStartDate()
    #         console.log t.picker.getEndDate()
    #         # Template.currentInstance()getStartDate

    Template.parse_this.events 
        'click .parse': ->
            Meteor.call 'parse', Session.get('fullview_id'), ->
    Template.complete_button.events 
        'click .mark_complete': ->
            # if confirm 'complete'
            Docs.update @_id, 
                $set:
                    complete:true
                    complete_timestamp:Date.now()
                    completed_user_id:Meteor.userId()
                    completed_username:Meteor.user().username
        'click .mark_incomplete': ->
            # if confirm 'complete'
            Docs.update @_id, 
                $set:
                    complete:false
                    complete_timestamp:Date.now()
                    completed_user_id:Meteor.userId()
                    completed_username:Meteor.user().username

if Meteor.isClient
    Template.registerHelper 'is', (key,val) -> @["#{key}"] is val
    Template.registerHelper 'can_edit', () -> @_author_id is Meteor.userId()
    Template.registerHelper '_when', () -> moment(@_timestamp).fromNow()
    Template.registerHelper 'is_editing', () -> Session.equals('editing',true)

    Template.registerHelper 'from_now', (input) -> moment(input).fromNow()
    Template.registerHelper '_author', () -> Meteor.users.findOne @_author_id
    
            
if Meteor.isClient
    @picked_tags = new ReactiveArray []
        
    Template.model_dropdown.helpers
        current_model_filter: ->
            Session.get('model_filter')
    Template.remove_button.events
        'click .delete': ->
            if confirm 'delete'
                Docs.remove @_id
    Template.loom.events
        'click .add_new_doc': ->
            new_id = 
                Docs.insert 
                    published:'false'
                    publish_status:'draft'
            Meteor.users.update Meteor.userId(),
                $set:
                    current_route:'doc_edit'
                    current_doc_id:new_id
        'click .unpick_tag': (e,t)->
            picked_tags.remove @valueOf()
        'click .clear_search': (e,t)->
            Session.set('current_query', null)
            t.$('.current_query').val('')
            
        # 'keyup .search_site': _.throttle((e,t)->
        'keyup .ai_input': (e,t)->
            # query = $('.search_site').val()
            search = t.$('.ai_input').val()
            if e.which is 13
                $(e.currentTarget).closest('.ai_input').transition('pulse', 100)
                Meteor.call 'ai', search, ->
                # Session.set('current_query', search)
                $('.ai_input').val('')
                $('body').toast({title: "submitting: #{search}"})
        'click .submit_ai': (e,t)->
            # query = $('.search_site').val()
            search = t.$('.ai_input').val()
            $(e.currentTarget).closest('.ai_input').transition('pulse', 100)
            Meteor.call 'ai', search, ->
            # Session.set('current_query', search)
            $('.ai_input').val('')
            $('body').toast({title: "submitting: #{search}"})

                
        'keyup .search_site': (e,t)->
            # query = $('.search_site').val()
            search = t.$('.search_site').val().trim().toLowerCase()
            if search.length > 2
                Session.set('current_query', search)
            # console.log 'hi'
            #     # Session.set('current_query', search)
            #     console.log 'searching', search
            if e.which is 8
                if search.length is 0
                    Session.set('current_query', null)
            if e.which is 13
                $(e.currentTarget).closest('.search_site').transition('pulse', 100)
    
                Session.set('current_query', search)
                
                # console.log Session.get('current_query')
                # console.log 'hi'
                picked_tags.push search
                synth = window.speechSynthesis
                utterThis = new SpeechSynthesisUtterance(search)
                synth.speak(utterThis)
                $('.search_site').val('')
            if e.which is "Escape"
                Session.set('current_query', null)
                $('.search_site').val('')
            # # e.which is keycode and 13 is 'enter'
            # if e.which is 13
            #     console.log e 
            #     console.log t
            #     if search.length > 0
            #         match = {}
            #         match.title =  {$regex:search, $options: 'i'}
            #         found_results = Docs.find(match).count()
            #         if found_results is 1
            #             found_result = Docs.findOne match 
            #             console.log found_result
            #             Meteor.users.update Meteor.userId(),
            #                 $addToSet:
            #                     history_ids:found_result._id
            #         else 
            #             picked_tags.push search
            #             Meteor.call 'call_icon', search, ->
            #             console.log 'search', search
            #         # Meteor.call 'log_term', search, ->
            #         $('.search_site').val('')
            #         Session.set('current_query', null)
                    
                    # # $('#search').val('').blur()
                    # # $( "p" ).blur();
                    # Meteor.setTimeout ->
                    #     Session.set('dummy', !Session.get('dummy'))
                    # , 10000
        # , 250)
    

if Meteor.isClient
    Template.loom.helpers
        my_drafts:->
            Docs.find 
                _author_id:Meteor.userId()
                publish_status:'draft'
        current_doc: ->
            if Meteor.user() and Meteor.user().current_doc_id
                Docs.findOne Meteor.user().current_doc_id
                    
        session_is: (key)-> Session.get("#{key}")
        # schema_count: -> Docs.find(model:'schema').count()
        is_searching: -> Session.get('current_query')
        # model_filters: -> model_filters.array()
        view_template: -> "#{@model}_view"
        edit_template: -> "#{@model}_edit"
        current_viewing_thing: ->
            Docs.findOne Session.get('current_thing_id')
        is_editing: -> Session.equals('editing',true)
        can_edit_this: ->
            if Session.get('fullview_id')
                cd = Docs.findOne Session.get('fullview_id')
                cd._author_id is Meteor.userId()
        doc_results: ->
            # Docs.find {model:$ne:'comment'},
            match = {}
            if Session.get('current_query')
                match.title = {$regex:Session.get('current_query'), $options:'i'}
            # if Meteor.user() and Meteor.user().eft_filter_array and Meteor.user().eft_filter_array.length > 0
            #     match.efts = $in:Meteor.user().eft_filter_array
            # if model_filters.array().length
            if Session.get('model_filter')
                # match.model = $in:model_filters.array()
                match.model = Session.get('model_filter')
            # else 
                # match.model = $nin:['model','comment','message'] 
            Docs.find match,
                sort:_timestamp:-1
                limit:20
        view_latest_class: -> 
            if Session.get('view_latest') then 'large active' else 'compact basic'
        fullview_doc: ->
            if Session.get('fullview_id')
                Docs.findOne Session.get('fullview_id')
    Template.loom.events
        'click .remove_tag': ->
            # console.log @
            Docs.update Session.get('fullview_id'), 
                $pull:tags:@valueOf()
            tag = $('.add_tag').val(@valueOf())
    Template.full_view.events
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
    Template.loom.events
        'click .view_latest': ->
            # trying different view session storage
            current_role = Docs.findOne Meteor.user().current_role_id
            if current_role
                Docs.update current_role._id, 
                    $set: view_latest:true
            if Session.get('view_latest')
                Session.set('view_latest',false)
            else 
                Session.set('view_latest',true)
                
            # Meteor.users.update Meteor.userId(),
            #     $set:view_latest:true
            $('body').toast({
                title: "viewing latest #{Session.get('view_latest')}"
                class : 'success'
                showProgress:'bottom'
                position:'bottom right'
            })
                
        'click .add_doc': ->
            new_id = 
                Docs.insert 
                    model:'post'
                    published:false
            Meteor.users.update Meteor.userId(),
                $set:
                    editing:true
                    _doc_id:new_id
        'click .logout': -> Meteor.logout()
        'click .clear_fullview': -> 
            Session.set('fullview_id',null)
            # $('body').toast('full view cleared')
        'click .unpick_model': -> 
            # model_filters.remove @valueOf()
            Session.set('model_filter',null)
        # 'click .show_modal': (e,t)->
        #     Session.set('current_thing_id', @_id)
        #     console.log @
        #     # $(e.currentTarget).closest('.ui.modal').modal({
        #     $('.ui.modal').modal({
        #         inverted:true
        #         # blurring:true
        #         }).modal('show')
    # Template.thing_maker.events 
    #     'click .show_modal': ->
    #         $('.ui.modal').modal({
    #             inverted:true
    #             }).modal('show')
    #         unless Session.get('current_thing_id')
    #             # unless Meteor.user().current_thing_id
    #             new_id = 
    #                 Docs.insert 
    #                     thing:true
    #             # Session.set('editing_thing_id')
    #             Session.set('current_thing_id', new_id)
    #             # Meteor.users.update Meteor.userId(),
    #             #     $set:
    #             #         current_thing_id: new_id
                
    #     'click .delete_thing':->
    #         if confirm 'delete?'
    #             Docs.remove @_id
    #             Session.set('current_thing_id', null)
    #             Meteor.users.update Meteor.userId(),
    #                 $unset:current_thing_id:1
    #     'click .add_thing':->
    #         new_id = 
    #             Docs.insert 
    #                 thing:true
    #         Meteor.users.update Meteor.userId(),
    #             $set:
    #                 current_thing_id: new_id
    # Template.thing_maker.helpers 
    #     current_thing:->
    #         # user = Meteor.user()
    #         # Docs.findOne user.current_thing_id
    #         Docs.findOne Session.get('current_thing_id')
if Meteor.isClient
    Template.loom.events 
        'click .pick_me': -> Session.set('fullview_id', @_id)
    Template.home_card.events 
        'click .pick_me': -> 
            Session.set('fullview_id', @_id)
            Docs.update @_id, 
                $inc:views:1
    Template.loom.onRendered ->
        # categoryContent = [
        #     { category:'eft', title:'food', color:"FF73EA", icon:'food' }
        #     { category:'eft', title:'housing', color:"B785E1", icon:'home' }
        #     { category:'eft', title:'clothing', color:"7229AF", icon:'tshirt' }
        #     { category:'eft', title:'transportation', color:"1255B8", icon:'car' }
        #     { category:'eft', title:'energy', color:"83DFF4", icon:'lightning' }
        #     { category:'eft', title:'zero waste', color:"42E8C4", icon:'leaf' }
        #     { category:'eft', title:'wellness', color:"40C057", icon:'smile' }
        #     { category:'eft', title:'education', color:"FAB005", icon:'university' }
        #     { category:'eft', title:'art', color:"FD7E14", icon:'paint brush' }
        #     { category:'eft', title:'community core', color:"FF0000", icon:'users' }
        #     { category:'model', title:'org' }
        #     { category:'model', title:'project' }
        #     { category:'model', title:'event' }
        #     { category:'model', title:'role' }
        #     { category:'model', title:'tasks' }
        #     { category:'model', title:'resource' }
        #     { category:'model', title:'post' }
        #     { category:'model', title:'offer' }
        #     { category:'model', title:'request' }
        #     { category:'model', title:'skills' }
        # ]
        $('.dropdown').dropdown({
            inline: true
          })
        # $('.ui.search')
        #   .search({
        #     type: 'category',
        #     source: categoryContent
        #     selectFirstResult:true	            
        #   })
        # $('.tabular.menu .item').tab();

    Template.loom.onCreated ->
        # alert 'hi'
        @autorun => @subscribe 'me', ->
        # @autorun => @subscribe 'users', ->
        @autorun => @subscribe 'tag_results', picked_tags.array(), ->
        @autorun => @subscribe 'current_user_doc', ->
        @autorun => @subscribe 'my_drafts', ->
        @autorun => @subscribe 'home_docs',
            Session.get('current_query')
            picked_tags.array()
            Session.get('model_filter')
            # model_filters.array()
            picked_tags.array()
            Session.get('view_latest')
            # Session.get('post_title_filter')
            ->

    
if Meteor.isClient    
    Template.filter_model.helpers
        button_class:->
            if @model is Session.get('model_filter')
                'large active'
            else 
                'small secondary basic'
            # if @model in model_filters.array()
            #     'gactive'
            # else 
            #     'small secondary'
            # if Session.equals('model_filter',@model) then 'blue large' else 'small'
            # if  @model in Meteor.user().model_filters then 'blue big' else 'small basic'
    Template.filter_model.events
        'click .pick_model': ->
            Session.set('model_filter',@model)
            
            # if @model in model_filters.array()
            #     model_filters.remove @model 
            # else 
            #     model_filters.push @model 
                
            # # if @model in Meteor.user().model_filters 
            # if @model in Meteor.user().model_filters 
            #     Meteor.users.update Meteor.userId(),
            #         $pull:
            #             model_filters:@model
            # else 
            #     Meteor.users.update Meteor.userId(),
            #         $addToSet:
            #             model_filters:@model
                
    
Meteor.methods
    upvote: (doc)->
        if Meteor.userId()
            if doc.downvoter_ids and Meteor.userId() in doc.downvoter_ids
                Docs.update doc._id,
                    $pull: downvoter_ids:Meteor.userId()
                    $addToSet: upvoter_ids:Meteor.userId()
                    $inc:
                        points:2
                        upvotes:1
                        downvotes:-1
            else if doc.upvoter_ids and Meteor.userId() in doc.upvoter_ids
                Docs.update doc._id,
                    $pull: upvoter_ids:Meteor.userId()
                    $inc:
                        points:-1
                        upvotes:-1
            else
                Docs.update doc._id,
                    $addToSet: upvoter_ids:Meteor.userId()
                    $inc:
                        upvotes:1
                        points:1
            # Meteor.users.update doc._author_id,
            #     $inc:karma:1
            Meteor.call 'calc_user_points', doc._author_id, ->
        else
            Docs.update doc._id,
                $inc:
                    anon_points:1
                    anon_upvotes:1
            Meteor.users.update doc._author_id,
                $inc:anon_karma:1

    downvote: (doc)->
        # for now, voting is 'free', target gets points, author doesnt lose them
        if Meteor.userId()
            if doc.upvoter_ids and Meteor.userId() in doc.upvoter_ids
                Docs.update doc._id,
                    $pull: upvoter_ids:Meteor.userId()
                    $addToSet: downvoter_ids:Meteor.userId()
                    $inc:
                        points:-2
                        downvotes:1
                        upvotes:-1
            else if doc.downvoter_ids and Meteor.userId() in doc.downvoter_ids
                Docs.update doc._id,
                    $pull: downvoter_ids:Meteor.userId()
                    $inc:
                        points:1
                        downvotes:-1
            else
                Docs.update doc._id,
                    $addToSet: downvoter_ids:Meteor.userId()
                    $inc:
                        points:-1
                        downvotes:1
            # Meteor.users.update doc._author_id,
            #     $inc:karma:-1
            Meteor.call 'calc_user_points', doc._author_id, ->
        else
            Docs.update doc._id,
                $inc:
                    anon_points:-1
                    anon_downvotes:1
            Meteor.users.update doc._author_id,
                $inc:anon_karma:-1
                
                
                
    calc_user_points: (user_id)->
        user = Meteor.users.findOne user_id 
        user_points = 0
        authored_docs = Docs.find(
            _author_id:user_id
            points:$exists:true
            )
        for doc in authored_docs.fetch()
            user_points += doc.points
            # doc_object = Docs.findOne doc._id
            # console.log 'doc object', doc
            # if doc.points 
        console.log 'user points', user.points, user_points
        Meteor.users.update user_id, 
            $set:points:user_points