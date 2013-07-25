Template.step2.rendered = ->
  if Session.equals 'step', 2
    console.log 'only step2'

    #setTimeout hack for now to not display the homepage(step1)
    #600ms is the same duration for the transitions
    setTimeout ( ->
      console.log 'wait'
      $('.from_homepage .current').css('display', 'none')
    ), 500

    d3.select('#signpad').append('svg')
      .attr('height', 150)
      .attr('width', 460)
      .attr('id', 'signature_pad')
      .style('background', '#ccc')

      $('.mic').slabText
        fontRatio: 0.7
        resizeThrottleTime: 0

      $('.instruction').slabText
        fontRatio: 0.4
        viewportBreakpoint: 380
        resizeThrottleTime: 0

      stS = "<span class='slabtext'>"
      stE = "</span>"
      txt = ["GOT A MICROPHONE?", "GOT A COMPUTER?", "GOT A TABLET?", "GOT A PHONE?", "GOT A GIZMODAD?", "READY, SET, JOT."]
      $("#myHeader").html(stS + txt.join(stE + stS) + stE).slabText()

Template.step2.events
  'click .goto3' : ->
    console.log 'click to 3'
    Session.set 'nextstep', true