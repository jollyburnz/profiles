Meteor.startup ->
  Session.set 'data_loaded', false

Meteor.subscribe 'emails', ->
  Session.set 'data_loaded', true