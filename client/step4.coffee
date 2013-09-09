Template.step4.rendered = ->
  if Session.equals 'step', 4
    console.log 'step 4!'

    $(window).scrollTop(0)

    setTimeout ( ->
      console.log 'wait'
      $('.from_step3 .current').css('display', 'none')
    ), 1000
    
    #Step Indicator appears on the bottom
    $('#bottom').css('bottom', '0')

    $('#blurb4-1').slabText
      fontRatio: 1
      resizeThrottleTime: 0

    $('#blurb4-2').slabText
      fontRatio: 1
      resizeThrottleTime: 0

Template.step4.events 
  "click #btn": ->  
    #Commented out to not send out email thru mailgun
    #if png
    #  Meteor.call "sendEmail", $("#email").val(), png
    Emails.insert 
      email: $("#email").val()
      avatar: Session.get 'path'
      share: Session.get 's3share'
      learn: Session.get 's3learn'

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