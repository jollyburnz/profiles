Meteor.startup ->
  Session.set 'data_loaded', false
  window.controller = $.superscrollorama
    triggerAtCenter: false
    playoutAnimations: true

Meteor.subscribe 'emails', ->
  Session.set 'data_loaded', true