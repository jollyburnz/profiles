Meteor.Router.add
  "/": 
    to: 'homepage'
    and: -> 
      Session.set 'step', 1
      Session.set 'nextstep', false
      Session.set 'next_step', '/step2'

  "/step2": 
    to: 'step2'
    and: -> 
      Session.set 'step', 2
      Session.set 'nextstep', false
      Session.set 'next_step', '/step3'

  "/step3": 
    to: 'step3'
    and: -> 
      Session.set 'step', 3
      Session.set 'nextstep', false
      Session.set 'next_step', '/step4'
  
  "/step4": 
    to: 'step4'
    and: -> 
      Session.set 'step', 4
      Session.set 'nextstep', false
      Session.set 'next_step', '/step5'

  "/browse": "browseList"
  "/pad": 'padview'
  '/transition': "transitiontest"
  "/flat": 'flat'
  '/test': "test1"
  "/:page" : (page) -> page