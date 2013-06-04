Template.portrait.done = ->
  Session.equals "done", true

Template.portrait.rendered = ->
  s2 = d3.select('#svgtest2').append('svg')
    .attr('width', 500)
    .attr('height', 500)

  Meteor.autorun ->
    data = Session.get 'path'
    if data
      console.log data, 'portraits'
      s2.selectAll('path').data(data)
        .enter()
        .append('path')
          .attr('d', (d) -> d.path_string)
          .attr('fill', 'none')
          .attr('stroke', 'gray')
          .attr('stroke-width', 4)