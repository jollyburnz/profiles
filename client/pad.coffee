renderAxes = (canvas) ->
  #console.log 'axes', @xAxis, @yAxis, @yScale, @xScale
  #axes crap
  @width = $(document).width()
  @height = $(document).height()
  console.log @width, @height, 'w/h'

  #each tick size would be initially 100px x 100px
  @xTickNum = Math.round @width/500
  @yTickNum = Math.round @height/500
  console.log @xTickNum, @yTickNum

  @xScale = d3.scale.linear()
    .domain([0, @width])
    .range([0, @width])

  @yScale = d3.scale.linear()
    .domain([@height, 0])
    .range([@height, 0])

  @xAxis = d3.svg.axis()
    .scale(@xScale)
    .orient('bottom')
    .ticks(@xTickNum)
    .tickSize(-@height)

  @yAxis = d3.svg.axis()
    .scale(@yScale)
    .orient("left")
    .ticks(@yTickNum)
    .tickSize(-@width)

  canvas.insert("g", ":first-child")
    .attr("class", "x-axis")
    .style("fill", "none")
    .attr("transform", "translate(0," + height + ")")
    .call(@xAxis) #xAxis still from the Cat
  .selectAll('g')
    .attr('class', 'x')
  .selectAll("line")
    .style("stroke", "#ecf0f1")

  canvas.insert("g", ":first-child")
    .attr("class", "y-axis")
    .style("fill", "none")
    .call(@yAxis) #yAxis is still from the Cat
  .selectAll('g')
    .attr('class', 'y')
  .selectAll("line")
    .style("stroke", "#ecf0f1")

pan_and_zoom = ->
  console.log @canvas
  console.log 'zoom test'
  #oldtx = window.tx
  #oldty = window.ty
  #olds = window.s
  #oldtx = window.tx || 0
  #oldty = window.ty || 0
  #olds = window.s || 1
  
  oldtx = 0
  oldty = 0
  olds = 1

  zoom = d3.behavior.zoom()
    .scaleExtent([0.1, 10])
    .on "zoom", (=>
      #window.tx = d3.event.translate[0] + oldtx * d3.event.scale|| 0
      #window.ty = d3.event.translate[1] + oldty * d3.event.scale|| 0
      #window.s = olds * d3.event.scale || 1
      window.tx = d3.event.translate[0] + oldtx * d3.event.scale
      window.ty = d3.event.translate[1] + oldty * d3.event.scale
      window.s = olds * d3.event.scale
      xys = [tx, ty, s]
      console.log "#{oldtx} x #{d3.event.scale} + #{d3.event.translate[0]} = #{tx}", ":: x"
      console.log "#{oldty} x #{d3.event.scale} + #{d3.event.translate[1]} = #{ty}", ":: y"
      console.log "#{olds} x #{d3.event.scale} = #{s}", ":: scale"
      console.log "----------------"
      console.log xys
      redraw(xys)
    )
  @canvas.call(zoom)

redraw = (xys) ->
  tx = xys[0]
  ty = xys[1]
  s = xys[2]
  #console.log xys, 'redraw coordinates'
  #number of ticks is based on the scale and dimensions, size of each tick is 100x100
  new_xTickNum = Math.round @width/(500*s)
  new_yTickNum = Math.round @height/(500*s)

  #new scale
  @newerxScale = d3.scale.linear()
    .domain([(0-tx)/s, (@width-tx)/s])

  @neweryScale = d3.scale.linear()
    .domain([(@height-ty)/s, (0-ty)/s])

  #translate the preview and playback svg
  d3.select(".svgavatars").attr("transform", "translate(#{tx}, #{ty})scale(#{s})")

  #pan and scale the ticks
  gx = @canvas.select('.x-axis').selectAll('g.x')
    .data(@newerxScale.ticks(new_xTickNum))
    .attr('transform', (d) => "translate(#{@xScale(d)*s+tx}, 0)")
  gy = @canvas.select('.y-axis').selectAll('g.y')
    .data(@neweryScale.ticks(new_yTickNum))
    .attr('transform', (d) => "translate(0, #{@yScale(d)*s+ty})")

  #update ticks
  gxe = gx.enter().insert('g')
    .attr("class", "x")
    .attr('transform', (d) => "translate(#{@xScale(d)*s+tx}, 0)")

  gxe.append('line')
    .attr("stroke", '#ecf0f1')
    .attr("y2", -@height)
    .attr("x2", 0)

  gx.exit().remove()

  gye = gy.enter().insert('g')
    .attr("class", "y")
    .attr('transform', (d) => "translate(0, #{@yScale(d)*s+ty})")

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

  renderAxes(@canvas)
  rendersvgPaths(@group)
  pan_and_zoom()

Template.pad.rendered = ->
  console.log 'this should render'
  rendersvg()