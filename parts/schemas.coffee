@schemas =
    # users:
    #     id: string
    #     username: string
    #     email: string
    #     password: string
    #     firstName: string
    #     lastName: string
    #     profilePicture: string
    #     bio: string
    #     location: {
    #         country: string
    #         state: string
    #         city: string
    #         zip: string
    #     }
    #     contact: {
    #         phone: string
    #         website: string
    #         socialMedia: {
    #             twitter: string
    #             instagram: string
    #             facebook: string
    #             linkedin: string
    #         }
    #     }
    #     skills: {
    #         skillId: string
    #         skillName: string
    #         skillLevel: string
    #         skillDescription: string
    #     }
    #     interests: {
    #         interestId: string
    #         interestName: string
    #     }
    #     requests: {
    #         requestId: string
    #         requestType: string
    #         requestDescription: string
    #         requestStatus: string
    #         createdDate: Date
    #         updatedDate: Date
    #     }
    #     offers: {
    #         offerId: string
    #         offerType: string
    #         offerDescription: string
    #         offerStatus: string
    #         createdDate: Date
    #         updatedDate: Date
    #     }
    #     products: {
    #         productId: string
    #         productName: string
    #         productDescription: string
    #         productPrice: number
    #         productImages: string
    #     }
    #     services: {
    #         serviceId: string
    #         serviceName: string
    #         serviceDescription: string
    #         servicePrice: number
    #         serviceImages: string
    #     }
    #     badges: {
    #         badgeId: string
    #         badgeName: string
    #         badgeDescription: string
    #         badgeImage: string
    #     }
    #     projects: {
    #         projectId: string
    #         projectName: string
    #         projectDescription: string
    #         projectStatus: string
    #         startDate: Date
    #         endDate: Date
    #         contributors: {
    #             contributorId: string
    #             contributorRole: string
    #         }
    #     }
    # }
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

        #     id: string
        #     eventName: String
        #     eventDescription: String
        #     eventLocation: {
        #         country: String
        #         state: String
        #         city: String
        #         zip: String
        #     }
        #     eventStartDate: Date
        #     eventEndDate: Date
        #     eventOrganizer: {
        #         organizerId: String
        #         organizerName: String
        #     }
        #     eventSponsors: {
        #         sponsorId: String
        #         sponsorName: String
        #     }
        #     eventAttendees: {
        #         attendeeId: String
        #         attendeeName: String
        #         attendeeStatus: String
        #         attendeeRole: String
        #     }
        #     eventTasks: {
        #         taskId: String
        #         taskName: String
        #         taskDescription: String
        #         taskDeadline: Date
        #         taskStatus: String
        #         taskAssignedTo: String
        #         taskCreatedBy: String
        #         taskBounty: {
        #             bountyType: String
        #             bountyAmount: number
        #         }
        #     }
        #     eventResources: {
        #         resourceId: String
        #         resourceName: String
        #         resourceDescription: String
        #         resourceType: String
        #         resourceOwner: String
        #         resourceLocation: {
        #             country: String
        #             state: String
        #             city: String
        #             zip: String
        #         }
        #         resourceRentStatus: String
        #         resourceRentee: String
        #         resourceProject: String
        #     }
        # }
            
            
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
                # id: String
                # author: User
                # title: String
                # body: String
                # attachments: Array of Attachment
                # tags: Array of String
                # created_at: Date
                # updated_at: Date
                # upvotes: Number
                # downvotes: Number
                # comments: Array of Comment
                # location: Location
                # visibility: String
                # privacy: String
                # status: String
                # featured: Boolean
                # promoted: Boolean
                # paid: Boolean
                # price: Number
                # currency: String
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
            
            # id: String,
            # title: String,
            # description: String,
            # category: String,
            # location: {
            #     address: String,
            #     city: String,
            #     state: String,
            #     country: String,
            #     latitude: Number,
            #     longitude: Number
            # },
            # budget: {
            #     amount: Number,
            #     currency: String
            # },
            # deadline: Date,
            # status: String,
            # requester: {
            #     id: String,
            #     name: String,
            #     email: String,
            #     phone: String,
            #     avatar: String
            # },
            # offers: [{
            #     id: String,
            #     provider: {
            #         id: String,
            #         name: String,
            #         email: String,
            #         phone: String,
            #         avatar: String
            #     },
            #     price: {
            #         amount: Number,
            #         currency: String
            #     },
            #     message: String,
            #     attachments: [{
            #         type: String,
            #         url: String,
            #         name: String,
            #         size: String
            #     }],
            #     status: String
            # }],
            # comments: [{
            #     id: String,
            #     author: {
            #         id: String,
            #         name: String,
            #         email: String,
            #         phone: String,
            #         avatar: String
            #     },
            #     message: String,
            #     attachments: [{
            #         type: String,
            #         url: String,
            #         name: String,
            #         size: String
            #     }],
            #     created_at: Date,
            #     edited_at: Date
            #     }]
            # }
            
            
        role:
            name:'Role'
            slug:'role'
        resource:
            name:'Resource'
            slug:'resource'
            # id: String
            # name: String
            # description: String
            # category: String
            # subcategory: String
            # type: String
            # status: String
            # location: {
            #     address: String
            #     city: String
            #     state: String
            #     country: String
            #     zip: String
            #     latitude: Float
            #     longitude: Float
            # }
            # images: [String]
            # tags: [String]
            # features: {
            #     rental: Boolean
            #     lending: Boolean
            #     contribution: Boolean
            #     bounties: Boolean
            #   }
            # rental: {
            #     availability: {
            #         start: DateTime
            #         end: DateTime
            #     }
            #     price: {
            #         amount: Float
            #         currency: String
            #         unit: String
            #     }
            #     deposit: {
            #         amount: Float
            #         currency: String
            #     }
            #     rules: {
            #         ageLimit: Int
            #         maxRenters: Int
            #         smokingAllowed: Boolean
            #         petsAllowed: Boolean
            #         otherRules: String
            #     }
            #     additionalInfo: {
            #         insurance: String
            #         delivery: Boolean
            #         pickup: Boolean
            #         otherInfo: String
            #     }
            # }
            # contribution: {
            #     availability: {
            #         start: DateTime
            #         end: DateTime
            #     }
            #     requirements: [String]
            #     benefits: [String]
            #     contactInfo: {
            #         email: String
            #         phone: String
            #     }
            # }
            # bounties: {
            #     cash: {
            #         currency: String
            #         amount: Float
            #     }
            #     points: {
            #         currency: String
            #         amount: Float
            #     }
            #     tokens: {
            #         currency: String
            #         amount: Float
            #     }
            #   }
            # owner: {
            #     id: String
            #     name: String
            #     email: String
            #   }
            # created_at: DateTime
            # updated_at: DateTime
            # }
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
            
        # 	id: ID!
        # 	name: String!
        # 	description: String
        # 	website: String
        # 	email: String
        # 	phone: String
        # 	address: String
        # 	city: String
        # 	state: String
        # 	zip: String
        # 	country: String
        # 	logoUrl: String
        # 	bannerUrl: String
        # 	tags: [String]
        # 	socialMedia: [SocialMedia]
        # 	members: [Member]
        # 	roles: [Role]
        # 	groups: [Group]
        # 	projects: [Project]
        # }
        
        # type SocialMedia {
        # 	platform: String!
        # 	url: String!
        # }
        
        # type Member {
        # 	id: ID!
        # 	firstName: String!
        # 	lastName: String!
        # 	email: String!
        # 	phone: String
        # 	address: String
        # 	city: String
        # 	state: String
        # 	zip: String
        # 	country: String
        # 	bio: String
        # 	avatarUrl: String
        # 	tags: [String]
        # }
        
        # type Role {
        #     id: ID!
        # 	name: String!
        # 	description: String
        # 	permissions: [String]
        # 	members: [Member]
        # }
        
        # type Group {
        # 	id: ID!
        # 	name: String!
        # 	description: String
        # 	members: [Member]
        # }
        
        # type Project {
        # 	id: ID!
        # 	name: String!
        # 	description: String
        # 	status: String
        # 	startDate: String
        # 	endDate: String
        # 	resources: [Resource]
        # 	tasks: [Task]
        # }
        
        # type Resource {
        # 	id: ID!
        # 	name: String!
        # 	description: String
        # 	type: String!
        # 	ownerId: ID!
        # 	ownerType: String!
        # 	status: String!
        # 	availableFrom: String
        # 	availableTo: String
        # 	location: String
        # 	rentalFee: Float
        # }
        
        # type Task {
        # 	id: ID!
        # 	name: String!
        # 	description: String
        # 	status: String!
        # 	startDate: String!
        # 	endDate: String!
        # 	assignee: Member
        # 	resources: [Resource]
        # 	comments: [Comment]
        # 	attachments: [Attachment]
        # }
        
        # type Comment {
        # 	id: ID!
        # 	content: String!
        # 	author: Member!
        # 	replies: [Comment]
        # 	createdAt: String!
        # }
        
        # type Attachment {
        # 	id: ID!
        # 	type: String!
        # 	url: String!
        # 	description: String
        # }
        
        # type Query {
        # 	organization(id: ID!): Organization
        # 	organizations: [Organization]
        # }
        
        # type Mutation {
        # 	createOrganization(name: String!, description: String, website: String, email: String, phone: String, address: String, city: String, state: String, zip: String, country: String, logoUrl: String, bannerUrl: String): Organization
        # 	updateOrganization(id: ID!, name: String, description: String, website: String, email: String, phone: String, address: String, city: String, state: String, zip: String, country: String, logoUrl: String, bannerUrl: String): Organization
        # 	deleteOrganization(id: ID!): Boolean
        # }
                    
            
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
