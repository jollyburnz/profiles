Meteor.Router.add
	"/": 'homepage'
	"/browse": "browseList"
	"/pad": 'padview'
	'/transition': "transitiontest"
	"/step2": 'step2'
	"/step3": 'step3'
	"/step4": 'step4'
	'/test': "test1"
	"/:page" : (page) -> page