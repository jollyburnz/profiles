Template.slider.helpers
	currentScreen: ->
	  console.log Meteor.Transitioner.currentPage(), 'current'
	  Meteor.Transitioner.currentPage()

	nextScreen: ->
	  console.log Meteor.Transitioner.nextPage(), 'next'
	  Meteor.Transitioner.nextPage()
