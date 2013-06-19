root = exports ? this
root.Paths = (() ->
  drawPaths = (points, paper, attributes, callback) ->
    path = points2path(points)
    drawing = paper.append('path')
    drawing.attr "d", path

    for a of attributes
      drawing.attr a, attributes[a]

    callback path
    ### JACKSON'S
    paths = simplify(points2paths(points), 0.05)
    path_string = paths2string(paths)

    drawing = paper.append('path')
    drawing.attr "d", path_string

    for a of attributes
      drawing.attr a, attributes[a]

    callback {drawing: drawing, path_string: path_string}
    ###

    ### CARL'S
    drawings = []
    path = ""
    for p of paths
      p = paths[p]
      drawings[p] = paper.append("path")
      drawings[p].attr "d", "M" + p.c0.x + "," + p.c0.y + "C" + p.c1.x + "," + p.c1.y + " " + p.c2.x + "," + p.c2.y + " " + p.c3.x + "," + p.c3.y
      path += "M" + p.c0.x + "," + p.c0.y + "C" + p.c1.x + "," + p.c1.y + " " + p.c2.x + "," + p.c2.y + " " + p.c3.x + "," + p.c3.y
      for a of attributes
        drawings[p].attr a, attributes[a]
    callback path
    ###

  points2paths = (points) ->
    times = numeric.linspace(0, points.length - 1)
    spline = numeric.spline(times, points)
    spline2paths spline
  spline2paths = (spline) ->
    paths = []
    t = 1

    while t < spline.x.length

      # The end control points are simply the nodes of the segment.
      # The inner control points are 1/3 down the slope vector at the nodes,
      # in the t-increasing direction for the first node, and t-decreasing
      # for the second.
      paths.push
        c0:
          x: spline.yl[t - 1][0]
          y: spline.yl[t - 1][1]

        c1:
          x: spline.yl[t - 1][0] + spline.kl[t - 1][0] / 3
          y: spline.yl[t - 1][1] + spline.kl[t - 1][1] / 3

        c2:
          x: spline.yl[t][0] - spline.kl[t][0] / 3
          y: spline.yl[t][1] - spline.kl[t][1] / 3

        c3:
          x: spline.yl[t][0]
          y: spline.yl[t][1]

      t++
    paths
  string2paths = (pathString) ->
    splitPoints = /M/ #split into individual beziers
    pathStrings = pathString.split(splitPoints)
    pathStrings.splice 0, 1 #cut off the empty leading string
    splitPoints = /[A-z ,]/ #split into individual values
    paths = []
    for i of pathStrings
      split = pathStrings[i].split(splitPoints)
      paths.push
        c0:
          x: parseFloat(split[0])
          y: parseFloat(split[1])

        c1:
          x: parseFloat(split[2])
          y: parseFloat(split[3])

        c2:
          x: parseFloat(split[4])
          y: parseFloat(split[5])

        c3:
          x: parseFloat(split[6])
          y: parseFloat(split[7])

    paths
  paths2string = (paths) ->
    pathString = ""
    p = undefined
    for i of paths
      p = paths[i]
      pathString += "M" + p.c0.x + "," + p.c0.y + "C" + p.c1.x + "," + p.c1.y + " " + p.c2.x + "," + p.c2.y + " " + p.c3.x + "," + p.c3.y
    pathString
  evalBezier = (p, t) ->
    r = 1 - t
    value =
      x: (r * r * r * p.c0.x) + (3 * r * r * t * p.c1.x) + (3 * r * t * t * p.c2.x) + (t * t * t * p.c3.x)
      y: (r * r * r * p.c0.y) + (3 * r * r * t * p.c1.y) + (3 * r * t * t * p.c2.y) + (t * t * t * p.c3.y)
  simplify = (pathSet, tolerance) ->
    path0 = pathSet.slice(0, pathSet.length / 2);
    path1 = pathSet.slice(pathSet.length / 2);
    console.log "started with", path0, path1
    if path0.length > 1
      path0 = simplify(path0, tolerance)
      console.log "path0 became ", path0
    if path1.length > 1
      path1 = simplify(path1, tolerance)
      console.log "path1 became ", path1
    outcome = merge(path0[path0.length - 1], path1[0], tolerance)
    if outcome.success
      console.log "success!"
      pathSet = path0.slice(0, path0.length - 1)
      pathSet.push(outcome.mergedPath)
      pathSet = pathSet.concat(path1.slice(1))
    else
      console.log "failure"
      pathSet = path0.slice(0)
      pathSet = pathSet.concat(path1.slice(0))
    ###
    j = 0
    path0 = undefined
    path1 = undefined
    while j < pathSet.length - 1
      path0 = pathSet.splice(j, 1)
      path1 = pathSet.splice(j, 1)
      outcome = merge(path0[0], path1[0], tolerance)
      if outcome.success
        pathSet.splice j, 0, outcome.mergedPath
      else
        pathSet.splice j, 0, path0[0], path1[0]
        j++
    ###
    console.log "after simplification we found ", pathSet
    pathSet.slice(0)
  merge = (path0, path1, threshold) ->
    t = (path0.c3.x - path0.c2.x) / (path1.c1.x - path0.c2.x)
    oldPoint = path1.c0
    mergedPath =
      c0:
        x: path0.c0.x
        y: path0.c0.y

      c1:
        x: ((path0.c1.x - path0.c0.x) / t) + path0.c0.x
        y: ((path0.c1.y - path0.c0.y) / t) + path0.c0.y

      c2:
        x: ((path1.c2.x - path1.c3.x) / (1 - t)) + path1.c3.x
        y: ((path1.c2.y - path1.c3.y) / (1 - t)) + path1.c3.y

      c3:
        x: path1.c3.x
        y: path1.c3.y

    newPoint = evalBezier(mergedPath, t)
    error = Math.sqrt(Math.pow(newPoint.x - oldPoint.x, 2) + Math.pow(newPoint.y - oldPoint.y, 2))
    scale = (Math.sqrt(Math.pow(path0.c0.x - oldPoint.x, 2) + Math.pow(path0.c0.y - oldPoint.y, 2)) + Math.sqrt(Math.pow(path1.c3.x - oldPoint.x, 2) + Math.pow(path1.c3.y - oldPoint.y, 2))) / 2
    console.log error / scale
    if error / scale < threshold
      mergedPath: mergedPath
      success: true
    else
      success: false

  points2path = (points) ->
    times = numeric.linspace(0, points.length - 1)
    spline2path(numeric.spline(times, points))


  spline2path = (spline) ->
    x0 = undefined
    y0 = undefined
    x1 = undefined
    y1 = undefined
    pathText = "M" + spline.yl[0][0] + "," + spline.yl[0][1]
    for t of spline.x

      # The control points are 1/3 down the slope vector at the nodes
      # For all but the first, we need only the t-decreasing control point
      # as the S(mooth) SVG path command takes the reflection of the previous
      # control point over the previous node to guarantee smoothness.
      x0 = spline.yl[t][0] - spline.kl[t][0] / 3
      y0 = spline.yl[t][1] - spline.kl[t][1] / 3
      if t > 1
        pathText += "S" + x0 + "," + y0 + " " + spline.yl[t][0] + "," + spline.yl[t][1]
      else if t > 0

        # if t === 1 begin the chain of bezier curves with a C(ubic) SVG
        # path command, using the control point gathered the previous iteration
        pathText += "C" + x1 + "," + y1 + " " + x0 + "," + y0 + " " + spline.yl[t][0] + "," + spline.yl[t][1]
      else

        # if t === 0 we need to save the forward-pointing control point.
        # The first C(ubic Bezier) SVG path command needs both control points
        # as it lacks a predecessor to reflect.
        x1 = spline.yl[t][0] + spline.kl[t][0] / 3
        y1 = spline.yl[t][1] + spline.kl[t][1] / 3
    pathText

  drawPaths: drawPaths
  p2path: points2path
)()