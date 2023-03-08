# Cloudinary.config
#     cloud_name: 'facet'
#     api_key: Meteor.settings.cloudinary_key
#     api_secret: Meteor.settings.cloudinary_secret


Meteor.methods 
    # parse: (parent_id)->
    #     parent = Docs.findOne parent_id 
    #     if parent
    #         console.log 'parsing', parent
            
    ai_add_tags: (data,parent_id)->
        console.log 'taggin',data
    create_ai_doc: (data, input)->
        console.log 'making ai doc', data
        Docs.insert 
            model:'ai'
            res:data
            title:input
            body:data.choices[0].text

Meteor.methods 
    import_model:(model)->
        # import event.coffee
        schemas.models.push event_file


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
        # match.model = $in:essentials
        match.model = $ne:'comment'
        
    # console.log 'home match', match, model_filter
    result_count = Docs.find(match).count()
    console.log result_count
    Docs.find match,
        limit:20
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


# Meteor.publish 'tag_results', (
#     picked_tags=[]
#     # picked_subreddit=null
#     # picked_author=null
#     # query
#     # searching
#     # dummy
#     )->

#     self = @
#     match = {}

#     # match.model = $in: ['reddit','wikipedia']
#     # match.model = $ne: 'comment'
#     # if query
#     if picked_tags.length > 0
#         match.tags = $all: picked_tags
#     # if picked_subreddit
#     #     match.subreddit = picked_subreddit
#     limit = 20
#     # else
#     #     limit = 10
#     #     match._timestamp = $gt:moment().subtract(1, 'days')
#     # else /
#         # match.tags = $all: picked_tags
#     console.log 'tag match', match
#     agg_doc_count = Docs.find(match).count()
#     tag_cloud = Docs.aggregate([
#         { $match: match }
#         { $project: "tags": 1 }
#         { $unwind: "$tags" }
#         { $group: _id: "$tags", count: $sum: 1 }
#         # { $match: _id: $nin: picked_tags }
#         # { $match: count: $lt: agg_doc_count }
#         # { $match: _id: {$regex:"#{current_query}", $options: 'i'} }
#         { $sort: count: -1, _id: 1 }
#         { $limit: 11 }
#         { $project: _id: 0, name: '$_id', count: 1 }
#     ], {})
#     # ], {
#     #     allowDiskUse: true
#     # }

#     tag_cloud.forEach (tag, i) =>
#         self.added 'results', Random.id(),
#             name: tag.name
#             count: tag.count
#             model:'tag'
#             # index: i
    
#     self.ready()
#     # else []
