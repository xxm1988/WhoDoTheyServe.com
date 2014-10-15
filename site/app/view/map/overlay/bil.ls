V = require \../../../view
E = require \./bil/edge
N = require \./bil/node

var d3f, ga, gs

V.map.on \pre-render, (entities) ->
  entities.edges = E.filter entities.edges
  entities.nodes = N.filter entities.nodes

V.map.on \render ->
  function add-handler g, event
    V.map-toolbar.on event, -> g.attr \display, if it then '' else \none

  d3f := @d3f
  ga  := @svg.append \svg:g .attr \class, \bil-attend
  gs  := @svg.append \svg:g .attr \class, \bil-steer

  N.render @svg, E.edges-attend
  add-handler ga, \toggle-bil-attend
  add-handler gs, \toggle-bil-steer

V.map.on \pre-cool, ->
  E.render-clear!

V.map.on \cooled, ->
  E.render-attend ga, d3f
  E.render-steer  gs, d3f
