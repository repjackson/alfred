Router.route '/calendar', (->
    @layout 'layout'
    @render 'cal'
    ), name:'cal'    
Template.cal.onRendered ->
    # calendarEl = document.getElementById('cal')
    # calendar = new Calendar(calendarEl, {
    #   plugins: [
    #     interactionPlugin,
    #     dayGridPlugin
    #   ],
    #   initialView: 'timeGridWeek',
    #   editable: true,
    #   events: [
    #     { title: 'Meeting', start: new Date() }
    #   ]
    # })
    
    # calendar.render()

    