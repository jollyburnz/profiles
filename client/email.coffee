Template.email.paths = ->
  paths = Session.get 'path'
  console.log paths, 'PATHSSSS'
  paths

Template.email.events 
  "click #btn": ->  
    # if someone click on the button ( tag), then we ask the server to execute the function sendEmail (RPC call)
    svg = $('#svgtest')[0]
    svg_xml = (new XMLSerializer).serializeToString(svg)
    console.log svg, svg_xml
    canvg(document.getElementById('canvastest'), svg_xml)
    canvas = document.getElementById("canvastest")
    png = canvas.toDataURL("image/png")

    #Commented out to not send out email thru mailgun
    #if png
    #  Meteor.call "sendEmail", $("#email").val(), png
      
    Emails.insert 
    	email: $("#email").val()
    	avatar: Session.get 'path'

    Session.set "done", true
    
    #go to your avatar lot on the infinite canvas
    max_row = Math.ceil Math.sqrt(Emails.find().count())
    count = Emails.find().count() - 1
    width = 500
    wwidth = $(window).width()
    wheight = $(window).height()

    Session.set 'tx', -count%max_row*width + wwidth/2 - width/2
    Session.set 'ty', -Math.floor(count/max_row)*width + wheight/2 - width/2
    Session.set 's', 1
    #go to padview
    Meteor.Router.to 'padview'

Template.email.done = ->
  Session.equals "done", true