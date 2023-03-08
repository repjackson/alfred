[1mdiff --git a/parts/schemas.coffee b/parts/schemas.coffee[m
[1mindex 6e211ea..07c21fc 100644[m
[1m--- a/parts/schemas.coffee[m
[1m+++ b/parts/schemas.coffee[m
[36m@@ -37,13 +37,17 @@[m
             field_list:['title','author', ][m
         events:[m
             name:'Events'[m
[32m+[m[32m            slug:'event'[m
             parent_models:['post'][m
             fields: [[m
[31m-                name:'title'[m
[31m-                # title: {[m
[31m-                #     field_type:'text'[m
[31m-                #     icon:'header'[m
[31m-                # }[m
[32m+[m[32m                {[m
[32m+[m[32m                    name:'title'[m
[32m+[m[32m                    type:'text'[m
[32m+[m[32m                    index:1[m
[32m+[m[32m                    icon:'header'[m
[32m+[m[32m                    can_edit: ->[m
[32m+[m[32m                        Meteor.userId()[m
[32m+[m[32m                }[m
             ][m
             viewing_roles:['admin','author'][m
             point_view_cost:'number'[m
[36m@@ -69,7 +73,8 @@[m
                 holder:[m
                     field_type:'user'[m
                     icon:'user'[m
[31m-    field_types: [][m
[32m+[m[32m    field_types:[m
[32m+[m[32m        text:[m
     methods: [m
         complete_task: ->[m
             # notify user [m
