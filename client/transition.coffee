Meteor.startup ->
	PageTransitions()

Template.transitiontest.rendered = ->
	console.log 'transition rendered'
