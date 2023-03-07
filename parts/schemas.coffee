@schemas = {
    name:'hi there'
    models: {
        events: {
            name:'Events'
            parent_models:['post']
            fields: [
                name:'title'
                # title: {
                #     field_type:'text'
                #     icon:'header'
                # }
            viewing_roles:['admin','author']
            point_view_cost:10
            purchased_users:['user1']
            ]
        }
        posts: {
            name:'Posts'
            # parent_models:['post']
            fields: {
                title: {
                    field_type:'text'
                    icon:'header'
                }
                
            }
        }
   }
}
