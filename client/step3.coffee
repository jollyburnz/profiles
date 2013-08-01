Scrollorama = ->
  controller = $.superscrollorama
    triggerAtCenter: false
    playoutAnimations: true

  controller.addTween ".blurb3-2"
    , TweenMax.from($(".blurb3-2"), .5, {css: {opacity: 0}})
    , 0 # scroll duration of tween (0 means autoplay)
    , -400 # offset the start of the tween by -400 pixels

  controller.addTween ".question-1-container"
    , TweenMax.from($(".question-1-container"), .5, {css: {opacity: 0}})
    , 0 # scroll duration of tween (0 means autoplay)
    , -400 # offset the start of the tween by -400 pixels
  
  controller.addTween ".question-2-container"
    , TweenMax.from($(".question-2-container"), .5, {css: {opacity: 0}})
    , 0 # scroll duration of tween (0 means autoplay)
    , -400 # offset the start of the tween by -400 pixels

Template.step3.rendered = ->
  if Session.equals 'step', 3
    console.log 'step 3!'

    $('.blurb3-1').slabText
      fontRatio: 1
      resizeThrottleTime: 0

    $('.blurb3-2').slabText
      fontRatio: 1
      resizeThrottleTime: 0

    $('.question-1').slabText
      fontRatio: 1.2
      resizeThrottleTime: 0

    $('.question-2').slabText
      fontRatio: 1.3
      resizeThrottleTime: 0

    Scrollorama()


  Meteor.autorun ->
    if Session.get('s3learn')? and Session.get('s3share')?
      Session.set 'nextstep', true



Template.step3.events
  'focus #share': (e, t) ->
      console.log 'focus'
      console.log t.find('.input-container')
      #${t.find('.input-ph')).css('color', '#ccc')
      $(e.target).css({'border-bottom':'1px solid #4FB975', 'color': '#4FB975', 'background': '#eee'})
      $(e.target).siblings('.input-ph').css('color', '#4FB975')
      #$(t.find('.input-ph')).css('color', '#4FB975')

  'blur #share': (e,t) ->
    console.log 'blur for share'
    console.log $('#share').val()
    Session.set 's3share', $('#share').val()
    $(e.target).css({'border-bottom':'1px solid #000', 'color': '#000', 'background': '#fff'})
    $(e.target).siblings('.input-ph').css('color', '#000')
    #$(t.find('.input-ph')).css('color', '#000')


  'focus #learn': (e, t) ->
    console.log 'focus'
    console.log t.find('.input-container')
    #${t.find('.input-ph')).css('color', '#ccc')
    $(e.target).css({'border-bottom':'1px solid #4FB975', 'color': '#4FB975', 'background': '#eee'})
    $(e.target).siblings('.input-ph').css('color', '#4FB975')
    #$(t.find('.input-ph')).css('color', '#4FB975')

  'blur #learn': (e,t) ->
    console.log 'blur for learn'
    console.log $('#learn').val()
    Session.set 's3learn', $('#learn').val()
    $(e.target).css({'border-bottom':'1px solid #000', 'color': '#000', 'background': '#fff'})
    $(e.target).siblings('.input-ph').css('color', '#000')
    #$(t.find('.input-ph')).css('color', '#000')

###
  'blur #learn': ->
    console.log 'blur for learn'
    console.log $('#learn').val()
    Session.set 's3learn', $('#learn').val()
###