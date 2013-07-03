Template.slider.helpers
	currentScreen: ->
	  console.log Meteor.Transitioner.currentPage(), 'current'
	  Meteor.Transitioner.currentPage()

	nextScreen: ->
	  console.log Meteor.Transitioner.nextPage(), 'next'
	  Meteor.Transitioner.nextPage()

Template.bottom.step = ->
	Session.get 'step'

Template.bottom.rendered = ->
	console.log 'bottom'
	$('.bottom-slide').find('li').each ->
		console.log $(@).text()
		console.log Session.get 'step'
		if Session.get('step').toString() == $(@).text().toString()
			console.log 'dope'
			$(@).addClass 'active'

Template.test1.rendered = ->
	Session.set 'step', 4


Template.step2.rendered = ->
	Session.set 'step', 2

Template.step3.rendered = ->
	Session.set 'step', 3

Template.step4.rendered = ->
	Session.set 'step', 4

Template.step4.events 
  "click #btn": ->  
    #Commented out to not send out email thru mailgun
    #if png
    #  Meteor.call "sendEmail", $("#email").val(), png
    Emails.insert 
    	email: $("#email").val()
    	avatar: Session.get 'path'

    #go to your avatar lot on the infinite canvas
    max_row = Math.ceil Math.sqrt(Emails.find().count())
    count = Emails.find().count() - 1
    width = 500
    wwidth = $(window).width()
    wheight = $(window).height()

    Session.set 'tx', -count%max_row*width + wwidth/2 - width/2
    Session.set 'ty', -Math.floor(count/max_row)*width + wheight/2 - width/2
    Session.set 's', 1
    #go to padview
    Meteor.Router.to 'padview'
