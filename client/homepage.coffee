Template.slider.helpers
	currentScreen: ->
	  console.log Meteor.Transitioner.currentPage(), 'current'
	  Meteor.Transitioner.currentPage()

	nextScreen: ->
	  console.log Meteor.Transitioner.nextPage(), 'next'
	  Meteor.Transitioner.nextPage()

Template.homepage.rendered = ->
	console.log 'jotalog'
	#$('#jotalog').fitText()

	#$('#jotalog').bigtext
	#	childSelector: "> p"
	#
	$('.copy').slabText
		fontRatio: 0.7
		precision: 3
		postTweak: true

	$('.blurb').slabText
		fontRatio: 2
		precision: 3
		postTweak: true

	$('.slogan').slabText
		fontRatio: 0.78
		precision: 3
		postTweak: true
		viewportBreakpoint: 380

	$('.instruction').slabText
		fontRatio: 1.9
		precision: 3
		postTweak: true
		viewportBreakpoint: 380


	$('.fancy_title').fitText(1)

	#$(".fancy_title").lettering()

	$('.pad').waypoint('sticky',
		offset: '40px'
	)
	
	$('.pad').on 'mousedown', ->
		$(@).find('.instruction').fadeOut()

Template.bottom.step = ->
	Session.get 'step'

Template.bottom.rendered = ->
	Meteor.autorun ->
		console.log 'bottom'
		$('.bottom-slide').find('li').each ->
			console.log $(@).text()
			console.log Session.get 'step'
			if Session.get('step').toString() == $(@).text().toString()
				console.log 'dope'
				$(@).addClass 'active'
			else
				$(@).removeClass 'active'

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


Template.flat.rendered = ->
	Session.set 'step', 5

	# Some general UI pack related JS
	# Extend JS String with repeat method
	# 
	String::repeat = (num) ->
	  new Array(num + 1).join this

	(($) ->
	  
	  # Add segments to a slider
	  $.fn.addSliderSegments = (amount) ->
	    @each ->
	      segmentGap = 100 / (amount - 1) + "%"
	      segment = "<div class='ui-slider-segment' style='margin-left: " + segmentGap + ";'></div>"
	      $(this).prepend segment.repeat(amount - 2)


	  $ ->
	    
	    # Todo list
	    $(".todo li").click ->
	      $(this).toggleClass "todo-done"

	    
	    # Custom Select
	    $("select[name='herolist']").selectpicker
	      style: "btn-primary"
	      menuStyle: "dropdown-inverse"

	    
	    # Tooltips
	    $("[data-toggle=tooltip]").tooltip "show"
	    
	    # Tags Input
	    $(".tagsinput").tagsInput()
	    
	    # jQuery UI Sliders
	    $slider = $("#slider")
	    if $slider.length
	      $slider.slider(
	        min: 1
	        max: 5
	        value: 2
	        orientation: "horizontal"
	        range: "min"
	      ).addSliderSegments $slider.slider("option").max
	    
	    # Placeholders for input/textarea
	    $("input, textarea").placeholder()
	    
	    # Make pagination demo work
	    $(".pagination a").on "click", ->
	      $(this).parent().siblings("li").removeClass("active").end().addClass "active"

	    $(".btn-group a").on "click", ->
	      $(this).siblings().removeClass("active").end().addClass "active"

	    
	    # Disable link clicks to prevent page scrolling
	    $("a[href=\"#fakelink\"]").on "click", (e) ->
	      e.preventDefault()

	    
	    # Switch
	    $("[data-toggle='switch']").wrap("<div class=\"switch\" />").parent().bootstrapSwitch()
	    #console.log $("[data-toggle='switch']").wrap("<div class=\"switch\" />").parent().bootstrapSwitch(), 'asdfasdf'
	) jQuery
