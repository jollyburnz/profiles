Template.slider.helpers
  currentScreen: ->
    Meteor.Transitioner.currentPage()

  nextScreen: ->
    Meteor.Transitioner.nextPage()


Template.buttons.events 
  submit: (e, template) ->
    e.preventDefault()
    Meteor.Router.to "/" + template.find("input").value
