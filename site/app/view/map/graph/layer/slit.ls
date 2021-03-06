module.exports = (vg) ->

  vg.on \render ->
    @svg.selectAll \.node .append \svg:g
      .attr \class \slit

  vg.on \late-rendered ->
    const BADGE-WIDTH = 24
    @svg.selectAll \.slit .each ->
      slit = d3.select this
      badges = slit.selectAll \a
      if (n = badges.0.length)
        dx = - (n - 1) * (BADGE-WIDTH / 2)
        slit.attr \transform -> "translate(#{dx},-10)"
        badges.each (d, i) ->
          badge = d3.select this
            ..attr \transform -> "translate(#{i * BADGE-WIDTH},0)"
