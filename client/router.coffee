Meteor.Router.add
	"/": 'homepage'
	"/browse": "browseList"
	"/pad": 'padview'
	"/:page" : (page) -> page