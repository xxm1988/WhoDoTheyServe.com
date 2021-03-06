Data    = require \./map.json
Hive    = require \../../api/hive
M-Nodes = require \../../api/model/nodes

# supplementary data for rendering maps is stored in the hive since it's not core

module.exports =
  boot: (cb) ->
    err, nodes <- M-Nodes.find!lean!exec
    return cb err if err
    json = Hive.get \map
    value = if json then JSON.parse json else {}
    value.regions = get-regions nodes
    value.icons = get-icons nodes
    Hive.set \map, JSON.stringify value
    cb!

    ## helpers

    function get-regions nodes
      regions = []
      for node in nodes
        for d in Data.regions when node.name.match d.name
          regions.push id:node._id, class:d.class
      regions

    function get-icons nodes
      icons = []
      for node in nodes
        for d in Data.icons when node.name.match d.name
          o = id:node._id
          o.glyph ?= d.glyph
          o.image ?= d.image
          o.size  ?= d.size
          icons.push o
      icons
