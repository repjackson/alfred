@Docs = new Meteor.Collection 'docs'

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
    Template.alfred.helpers
        food_orders: ->
            user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find
                model:'food_order'
                # _author_id:user._id



if Meteor.isServer
    Meteor.publish 'user_public_food', (username)->
        target_user = Meteor.users.findOne(username:Router.current().params.username)
        Docs.find
            model:'message'
            target_user_id: target_user._id
            is_private:false

    Meteor.publish 'user_private_food', (username)->
        target_user = Meteor.users.findOne(username:Router.current().params.username)
        Docs.find
            model:'message'
            target_user_id: target_user._id
            is_private:true
            _author_id:Meteor.userId()


if Meteor.isClient
    $.cloudinary.config
        cloud_name:"facet"
    
    Template.registerHelper '_when', () -> moment(@_timestamp).fromNow()
    Template.registerHelper '_author', () -> Meteor.users.findOne @_author_id

    Template.alfred.onCreated ->
        @autorun => @subscribe 'chat', ->
        @autorun => @subscribe 'users', ->
            
    
if Meteor.isServer
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
            true
            # doc._author_id is userId or 'admin' in Meteor.user().roles
    
    Meteor.publish 'chat', ->
        Docs.find 
            model:'message'
            
    Meteor.publish 'users', ->
        Meteor.users.find {},
            fields:
                username:1
                image_id:1
                tags:1
            
            
            
            