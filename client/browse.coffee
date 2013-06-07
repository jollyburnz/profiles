Template.browseList.lists = ->
	Emails.find {}

Template.browseList.count = ->
	Emails.find().count()

Template.path.rendered = ->
	console.log 'woah', @.data, @.firstNode
	paths = @.data.avatar
	d3.select(@.firstNode).selectAll('path').data(paths)
		.enter()
		.append('path')
		.attr('d', (d) -> d.path_string)
		.attr('fill', 'none')
		.attr('stroke', 'black')
		.attr('stroke-width', 4)

Template.browseList.rendered = ->
	console.log $(@), 'browser'
	$(@).addClass 'pt-page-current'