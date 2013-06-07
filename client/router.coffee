Meteor.Router.add
	"/": 'homepage'
	"/browse": "browseList"
	"/pad": 'padview'
	'/transition': "transitiontest"
	'/test': "test1"
	"/:page" : (page) -> page