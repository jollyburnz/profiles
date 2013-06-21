Meteor.startup ->
  window.isDrawing = false
  window.minDistance = 6
  window.REDRAW_LAST = 12
  window.N_SMOOTH = 6
  window.SMOOTHNESS = 0.2
  window._points = []
  window.pathsss = []

startPath = (svg, x, y) ->
  #console.log svg, x, y
  path = document.createElementNS("http://www.w3.org/2000/svg", "path")
  path.classList.add('current-path')
  path.setAttribute('fill', 'none')
  path.setAttribute('stroke-width', 4)
  path.setAttribute('stroke', 'black')
  m = path.createSVGPathSegMovetoAbs(x, y)
  #console.log m, path.id
  path.pathSegList.appendItem m
  window.currentPath = path
  svg.appendChild path

distanceBetween = (x1, x2, y1, y2) ->
  Math.sqrt Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2)

lineTo = (x, y) ->
  l = currentPath.createSVGPathSegLinetoAbs(x, y)
  console.log l
  currentPath.pathSegList.appendItem l

redrawLast = (n) ->
  length = _points.length
  list = currentPath.pathSegList
  #console.log n, list, 'jlk'
  i = Math.max(1, length - n) # The first point is M, don't change it
  while i < length
    seg = list.getItem(i)
    point = _points[i]
    seg.x = point[0]
    seg.y = point[1]
    i++

smooth = (points) ->
  console.log points
  length = points.length
  # i + 2
  return  if length < 2
  ii = Math.max(length - N_SMOOTH, 0)
  i = length - 2

  while i > ii
    p1 = points[i]
    p2 = points[i + 1]
    p1[0] = p1[0] * (1 - SMOOTHNESS) + p2[0] * SMOOTHNESS
    p1[1] = p1[1] * (1 - SMOOTHNESS) + p2[1] * SMOOTHNESS
    i--

onPointerMove = (event) ->
  x = event.pageX
  y = event.pageY
  distance = distanceBetween(prevX, x, prevY, y)
  return  if distance < minDistance
  smooth _points
  redrawLast REDRAW_LAST
  lineTo x, y
  _points.push [x, y]
  prevX = x
  prevY = y

mousedown = (e) ->
  console.log 'down', e
  e.preventDefault()
  _points.length = 0
  _points.push [e.pageX, e.pageY]
  window.isDrawing = true
  startPath document.querySelector('#svgtest'), e.pageX, e.pageY

mousemove = (e) ->
  if isDrawing
    console.log 'move'
    onPointerMove(e)

mouseup = ->
  console.log 'up'
  window.isDrawing = false
  console.log _points, "POINTS!!!!!"
  #path_string = currentPath.attributes[4].value
  path_string = Paths.p2path _points
  pathsss.push {path_string: path_string}
  d3.select(@).selectAll('.current-path')
    .transition()
    .duration(500)
    .attr('stroke-width', 0)
    .remove()

  Session.set 'path', pathsss
 
Template.padtest.notdone = ->
  Session.equals "done", undefined

Template.padtest.rendered = ->
  svgtest = d3.select('#test').append('svg')
    .attr('width', 500)
    .attr('height', 500)
    .attr('id', 'svgtest')

  preview = svgtest.append('g').attr('class', 'preview')
    
  $('#svgtest')
    .on('mousedown', mousedown)
    .on('mousemove', mousemove)
    .on('mouseup', mouseup)

  Meteor.autorun ->
    data = Session.get 'path'
    if data

      console.log data, 'portraits'
      preview.selectAll('path').data(data)
        .enter()
        .append('path')
          .attr('d', (d) -> d.path_string)
          .attr('fill', 'none')
          .attr('stroke', 'black')
          .attr('stroke-width', 0)
        .transition()
        .duration(200)
          .attr('stroke-width', 4)