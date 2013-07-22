Template.step2.rendered = ->
  if Session.equals 'step', 2
    console.log 'only step2'

    #setTimeout hack for now to not display the homepage(step1)
    setTimeout (
      $('.from_homepage .current').css('display', 'none')
      ), 1000