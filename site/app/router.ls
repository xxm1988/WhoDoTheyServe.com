B  = require \backbone
_  = require \underscore
H  = require \./history
C  = require \./collection
F  = require \./fireprox
M  = require \./model
V  = require \./view
Vc = require \./view-composer
Vh = require \./view-handler

Router = B.Router.extend do
  after: ->
    Vh.ready!
  before: ->
    B.trigger \route-before
    Vh.reset!
  routes:
    ''                 : \graph
    \doc/about         : \doc_about
    \edge/edit/:id     : \edge_edit
    \edge/new          : \edge_edit
    \edge/:id          : \edge
    \edge/:id/:act     : \edge
    \edge/:id/:act/:id : \edge
    \edges             : \edges
    \fireprox          : \fireprox
    \graph             : \graph
    \home              : \home
    \node/edit/:id     : \node_edit
    \node/new          : \node_edit
    \node/:id          : \node
    \node/:id/:act     : \node
    \node/:id/:act/:id : \node
    \nodes             : \nodes
    \session           : \session
    \user              : \user
    \user/edit/:id     : \user_edit
    \user/signin       : \user_signin
    \user/signout      : \user_signout
    \user/signup       : \user_signup
    \user/:id          : \user
    \users             : \users
  doc_about   : -> V.doc-about.render!
  edge        : -> H.set-edge Vc.edge ...
  edge_edit   : -> V.edge-edit.render (M.Edge.create it), C.Edges
  edges       : Vc.edges
  fireprox    : F.setup-url
  graph       : -> V.graph.render!
  home        : -> V.home.render!
  node        : -> H.set-node-id Vc.node ...
  node_edit   : -> V.node-edit.render (M.Node.create it), C.Nodes
  nodes       : Vc.nodes
  session     : -> V.session.render!
  user        : Vc.user
  user_edit   : -> V.user-edit.render (M.User.create it), C.Users
  user_signin : -> V.user-signin.render M.Session.create!, C.Sessions
  user_signout: -> V.user-signout.render!
  user_signup : -> V.user-signup.render M.Signup.create!, C.Users
  users       : Vc.users

module.exports = new Router!