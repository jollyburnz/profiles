Template.slider.helpers
  currentScreen: ->
    console.log Meteor.Transitioner.currentPage(), 'current'
    Meteor.Transitioner.currentPage()

  nextScreen: ->
    console.log Meteor.Transitioner.nextPage(), 'next'
    Meteor.Transitioner.nextPage()

Scrollorama = ->
  controller = $.superscrollorama
    triggerAtCenter: false
    playoutAnimations: true

  controller.addTween "#bullets"
    , TweenMax.from($("#bullets"), .5, {css: {opacity: 0}})
    , 0 # scroll duration of tween (0 means autoplay)
    , -400 # offset the start of the tween by -400 pixels

  controller.addTween "#start-jotting", 
    (new TimelineLite()).append([
      TweenMax.from($("#start-jotting"), .5, {css: {opacity: 0}}), 
      TweenMax.to($("#bottom"), .5, {css: {bottom: 0}})
    ])
    , 0
    , -400 # offset the start of the tween by -400 pixels

  controller.addTween "#pad"
    , TweenMax.from($("#pad"), .5, {css: {opacity: 0}})
    , 0 # scroll duration of tween (0 means autoplay)
    , -400 # offset the start of the tween by -400 pixels

slabText = ->
  console.log 'slabtext'
  $('.copy').slabText
    fontRatio: 0.7
    resizeThrottleTime: 0

  $('.blurb').slabText
    fontRatio: 1.5
    resizeThrottleTime: 0

  $('.slogan').slabText
    fontRatio: 0.78
    viewportBreakpoint: 380
    resizeThrottleTime: 0

  $('.instruction').slabText
    fontRatio: 1.5
    viewportBreakpoint: 380
    resizeThrottleTime: 0

  $('.question').slabText
    fontRatio: 2.5
    viewportBreakpoint: 380
    resizeThrottleTime: 0

Template.homepage.rendered = ->
  if Session.equals 'step', 1
    console.log 'DOPEE!!!!!!'
    console.log 'jotalog'
    #$(".fancy_title").lettering()

    #$('.pad').waypoint('sticky',
    #  offset: '40px'
    #)
    $('.tlt').textillate
      loop: true
      in:
        effect: "tada"
        sync: false
        shuffle: true
      out:
        effect: "bounceOut"
        sync: false
        shuffle: true
    
    $('.pad').on 'mousedown', ->
      $(@).find('.question').fadeOut()

    setTimeout(slabText, 1)

    Scrollorama()

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

    if Session.get 'nextstep'
      console.log 'NEXT!!!!!!'
      $('#next').addClass('btn-primary')
        .removeClass('disabled')
        .attr('href', Session.get('next_step'))
    else
       $('#next').removeClass('btn-primary')
        .addClass('disabled')
        .removeAttr('href')

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
