Template.slider.helpers
  currentScreen: ->
    console.log Meteor.Transitioner.currentPage()
    Meteor.Transitioner.currentPage()

  nextScreen: ->
    console.log Meteor.Transitioner.nextPage()
    Meteor.Transitioner.nextPage()


Template.buttons.events 
  submit: (e, template) ->
    e.preventDefault()
    Meteor.Router.to "/" + template.find("input").value
