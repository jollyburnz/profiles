Meteor.Router.add
	"/": 'homepage'
	"/browse": "browseList"
	"/pad": 'padview'
	'/transition': "transitiontest"
	"/:page" : (page) -> page