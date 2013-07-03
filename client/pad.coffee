Meteor.startup ->
  Session.set 'tx', 0
  Session.set 'ty', 0
  Session.set 's', 1

  Session.set 'xtick', 1
  Session.set 'ytick', 1

  Session.set 'newxscale', null
  Session.set 'newyscale', null

renderAxes = (canvas) ->
  #console.log 'axes', @xAxis, @yAxis, @yScale, @xScale
  #axes crap
  @width = $(document).width()
  @height = $(document).height()
  @tx = Session.get 'tx'
  @ty = Session.get 'ty'
  @s = Session.get 's'


  @xtick = Session.get 'xtick'
  @ytick = Session.get 'ytick'

  console.log @width, @height, 'w/h', @xtick, @ytick

  #each tick size would be initially 100px x 100px
  @xTickNum = Math.round @width/500
  @yTickNum = Math.round @height/500

  console.log @xTickNum, @yTickNum

  @xScale = d3.scale.linear()
    .domain([ (0 - @tx) / @s, (@width - @tx) / @s])
    .range([0, @width])

  @yScale = d3.scale.linear()
    .domain([ (@height - @ty) / @s, (0 - @ty) / @s ])
    .range([@height, 0])

  @xAxis = d3.svg.axis()
    .scale(@xScale)
    .orient('bottom')
    #.ticks(@xTickNum)
    .ticks(Session.get('xtick'))
    .tickSize(-@height)

  @yAxis = d3.svg.axis()
    .scale(@yScale)
    .orient("left")
    #.ticks(@yTickNum)
    .ticks(Session.get('ytick'))
    .tickSize(-@width)

  @canvas.insert("g", ":first-child")
    .attr("class", "x-axis")
    .style("fill", "none")
    .attr("transform", "translate(0,#{height})")
    .call(@xAxis) #xAxis still from the Cat
  .selectAll('g')
    .attr('class', 'x')
  .selectAll("line")
    .style("stroke", "#ecf0f1")

  @canvas.insert("g", ":first-child")
    .attr("class", "y-axis")
    .style("fill", "none")
    .attr("transform", "translate(0,0)")
    .call(@yAxis) #yAxis is still from the Cat
  .selectAll('g')
    .attr('class', 'y')
  .selectAll("line")
    .style("stroke", "#ecf0f1")

pan_and_zoom = ->
  console.log @canvas
  console.log 'zoom test'
  
  oldtx = Session.get 'tx'
  oldty = Session.get 'ty'
  olds = Session.get 's'

  zoom = d3.behavior.zoom()
    .scaleExtent([0.1, 10])
    .on "zoom", (=>
      window.tx = d3.event.translate[0] + oldtx * d3.event.scale
      window.ty = d3.event.translate[1] + oldty * d3.event.scale
      window.s = olds * d3.event.scale

      xys = [tx, ty, s]
      #console.log "#{oldtx} x #{d3.event.scale} + #{d3.event.translate[0]} = #{tx}", ":: x"
      #console.log "#{oldty} x #{d3.event.scale} + #{d3.event.translate[1]} = #{ty}", ":: y"
      #console.log "#{olds} x #{d3.event.scale} = #{s}", ":: scale"
      #console.log "----------------"
      #console.log xys
      redraw(xys)
    )
  @canvas.call(zoom)

redraw = (xys) ->
  tx = xys[0]
  ty = xys[1]
  s = xys[2]

  Session.set 'tx', tx
  Session.set 'ty', ty
  Session.set 's', s

  #console.log xys, 'redraw coordinates'
  #number of ticks is based on the scale and dimensions, size of each tick is 100x100
  new_xTickNum = Math.round @width/(500*s)
  new_yTickNum = Math.round @height/(500*s)

  Session.set 'xtick', new_xTickNum
  Session.set 'ytick', new_yTickNum

  console.log tx, @width, @height, ty, s, 'befour'
  console.log (0-tx)/s, (@width-tx)/s, (@height-ty)/s, (0-ty)/s, 'four'

  #new scale
  @newerxScale = d3.scale.linear()
    .domain([(0-tx)/s, (@width-tx)/s])
    #.domain([(0-tx)/s, (@width-tx)/s])

  @neweryScale = d3.scale.linear()
    .domain([(@height-ty)/s, (0-ty)/s])
    #domain([(0-tx)/s, (@width-tx)/s])

  Session.set 'newxscale', @newerxScale.ticks(new_xTickNum)
  Session.set 'newyscale', @neweryScale.ticks(new_yTickNum)
 
  #translate the preview and playback svg
  d3.select(".svgavatars").attr("transform", "translate(#{tx}, #{ty})scale(#{s})")

  #pan and scale the ticks
  gx = @canvas.select('.x-axis').selectAll('g.x')
    .data(Session.get('newxscale'))
    .attr('transform', (d) => "translate(#{d*s+tx}, 0)")
  gy = @canvas.select('.y-axis').selectAll('g.y')
    .data(Session.get('newyscale'))
    .attr('transform', (d) => "translate(0, #{d*s+ty})")

  #update ticks
  gxe = gx.enter().insert('g')
    .attr("class", "x")
    .attr('transform', (d) => "translate(#{d*s+tx}, 0)")

  gxe.append('line')
    .attr("stroke", '#ecf0f1')
    .attr("y2", -@height)
    .attr("x2", 0)

  gx.exit().remove()

  gye = gy.enter().insert('g')
    .attr("class", "y")
    .attr('transform', (d) => "translate(0, #{d*s+ty})")

  gye.append('line')
    .attr("stroke", '#ecf0f1')
    .attr("y2", 0)
    .attr("x2", @width)

  gy.exit().remove()

rendersvgPaths = (group) ->
  #window.pathtest = Emails.find().fetch()
  #console.log pathtest
  width = 500
  #max_row = 5
  
  Meteor.autorun ->
    if Session.get 'data_loaded'
      console.log Emails.find().fetch()
      console.log Emails.find().count()

    #console.log window.tx, window.ty, window.s

    max_row = Math.ceil Math.sqrt(Emails.find().count())

    group.selectAll('g').data(Emails.find().fetch())
      .enter()
      .append('g').attr('class', 'test')
        .attr('transform', (d, i) ->
          "translate(#{i%max_row*width}, #{Math.floor(i/max_row)*width})"
        )
        .on 'mouseover', ->
          console.log 'over', @
          d3.select(@).selectAll('path')
            .transition()
            .duration(300)
            .attr('stroke', 'red')
        .on 'mouseout', ->
          d3.select(@).selectAll('path')
            .transition()
            .duration(300)
            .attr('stroke', 'black')    
        .selectAll('path').data((d) -> d.avatar)
        .enter()
          .append('path')
            .attr('d', (d)-> d.path_string)
            .attr('fill', 'none')
            .attr('stroke', 'black')
            .attr('stroke-width', 3)

rendersvg = ->
  @canvas = d3.select('#padddd')
    .attr('width', $(document).width())
    .attr('height', $(document).height())
  @group = @canvas.append('g').attr('class', 'svgavatars')
    .attr('transform', "translate(#{Session.get('tx')},#{Session.get('ty')}) scale(#{Session.get('s')})")

  renderAxes(@canvas)
  rendersvgPaths(@group)

  pan_and_zoom()

  #highlight the last new portrait
  d3.select(@group.selectAll('g')[0].pop()).selectAll('path')
    .attr('stroke', 'red')

Template.pad.rendered = ->
  Session.set 'step', 5
  rendersvg()

Template.pad.count = ->
  Emails.find().count()