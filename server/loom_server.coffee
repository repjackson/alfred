Meteor.methods 
    get_schemas: ->
        # dl = HTTP.get(Meteor.absoluteUrl("/schema.jsonld"))
        myjson = JSON.parse(Assets.getText("schema.jsonld"));

        # dl = HTTP.get(Meteor.absoluteUrl("/small.json"))
        # parsed = EJSON.parse(dl.content)
        # console.log _.keys(myjson)
        # console.log dl
        # Docs.remove({model:'schema'})
        for schema in myjson["@graph"][..3]
            # console.log schema["@id"]
            # console.log schema
            found_local_doc = 
                Docs.findOne 
                    model:'schema'
                    '@id':schema["@id"]
            if found_local_doc
                console.log 'found doc', found_local_doc
            else
                console.log 'not found doc', schema['@id']
                schema.model = 'schema'
                new_id = Docs.insert schema
                console.log Docs.findOne new_id
Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.cloudinary_key
    api_secret: Meteor.settings.cloudinary_secret

Docs.allow
    insert: (userId, doc) -> 
        true    
        # doc._author_id is userId
    update: (userId, doc) ->
        true
        # if doc.model in ['calculator_doc','simulated_rental_item','healthclub_session']
        #     true
        # else if Meteor.user() and Meteor.user().roles and 'admin' in Meteor.user().roles
        #     true
        # else
        #     doc._author_id is userId
    # update: (userId, doc) -> doc._author_id is userId or 'admin' in Meteor.user().roles
    remove: (userId, doc) -> 
        userId
        # doc._author_id is userId or 'admin' in Meteor.user().roles
Meteor.users.allow
    insert: (userId, doc) -> 
        true    
        # doc._author_id is userId
    update: (userId, doc) ->
        userId
        # if doc.model in ['calculator_doc','simulated_rental_item','healthclub_session']
        #     true
        # else if Meteor.user() and Meteor.user().roles and 'admin' in Meteor.user().roles
        #     true
        # else
        #     doc._author_id is userId
    # update: (userId, doc) -> doc._author_id is userId or 'admin' in Meteor.user().roles
    remove: (userId, doc) -> 
        userId
        # doc._author_id is userId or 'admin' in Meteor.user().roles

Meteor.publish 'current_user_doc', ->
    if Meteor.user() and Meteor.user().current_doc_id
        id = Meteor.user().current_doc_id
        console.log 'current user id', id
        Docs.find({_id:id},{limit:1})
Meteor.publish 'users', ->
    Meteor.users.find {},
        fields:
            username:1
            image_id:1
            tags:1
        
Meteor.publish 'model_docs', (model)->
    Docs.find 
        model:model
Meteor.publish 'my_drafts', ()->
    Docs.find 
        _author_id:Meteor.userId()
        # published:false
        publish_status:'draft'
# Meteor.publish 'home_docs_count', (query_object, sort_object)->
#     # if model 
#     Counts.publish this, 'food_product_counter', 
#         Docs.find({
#             model:'recipe'
#         })
#     return undefined    # otherwise coffeescript returns a Counts.publish

Meteor.publish 'home_docs', (
    search=null
    picked_tags=[]
    model_filter=null
    view_latest=false
    )->
    match = {}
    essentials = ['post','offer','request','org','project','event','role','task','resource','skill']
    # essentials = ['post']
    # user = Meteor.user()
    # console.log Meteor.user().model_filters
    if search 
        match.title = {$regex:search, $options:'i'}  
    # if model_filters.length > 0
    #     match.model = $in:model_filters
    sort_key = "_timestamp"
    # sort_key = "_timestamp"
    sort_direction = -1
    if picked_tags.length > 0
        match.tags = $in:picked_tags
    # if view_latest
    #     sort_key = '_timestamp'
    #     sort_direction = -1
    if model_filter
        match.model = model_filter
    else 
        match.model = $in:essentials
    # console.log 'home match', match, model_filter
    result_count = Docs.find(match).count()
    console.log result_count
    Docs.find match,
        limit:10
        sort:"#{sort_key}":sort_direction
        # fields:
        #     title:1
        #     model:1
        #     body:1
        #     image_id:1
        #     views:1
        #     points:1
        #     link:1
        #     tags:1
        #     parent_id:1
        #     efts:1
        #     _author_id:1
        #     _author_username:1
        #     _timestamp:1

# Meteor.publish 'post_docs', (
#     model_filters=[]
#     # title_filter
#     # picked_authors=[]
#     # picked_tasks=[]
#     # picked_locations=[]
#     # picked_timestamp_tags=[]
#     # product_query
#     # view_vegan
#     # view_gf
#     # doc_limit
#     # doc_sort_key
#     # doc_sort_direction
#     )->

#     self = @
#     match = {}
#     # match = {app:'pes'}
#     # match.model = 'post'
#     # match.group_id = Meteor.user().current_group_id
#     # if title_filter and title_filter.length > 1
#     #     match.title = {$regex:title_filter, $options:'i'}
    
#     # if view_vegan
#     #     match.vegan = true
#     # if view_gf
#     #     match.gluten_free = true
#     # if view_local
#     #     match.local = true
#     # if picked_authors.length > 0 then match._author_username = $in:picked_authors
#     if model_filters.length > 0 then match.model = $all:model_filters 
#     # if picked_locations.length > 0 then match.location_title = $in:picked_locations 
#     # if picked_timestamp_tags.length > 0 then match._timestamp_tags = $in:picked_timestamp_tags 
#     console.log match
#     Docs.find match, 
#         limit:10
#         sort:
#             _timestamp:-1
#         fields:
#             title:1
#             model:1
#             image_id:1
#             tags:1
#             _timestamp:1
#             _author_id:1
#             _author_username:1
#             body:1
#             points:1
#             views:1
#             parent_id:1
#             efts:1
Meteor.publish 'user_current_doc', ->
    if Meteor.user()
        Docs.find 
            _id: Meteor.user()._doc_id
