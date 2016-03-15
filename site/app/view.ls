F  = require \fs # browserified
Ve = require \./view-activity/edit
Vr = require \./view-activity/read
Vs = require \./view-activity/select

V-Footer  = require \./view/footer
V-Maps    = require \./view/maps
V-NavBar  = require \./view/navbar
V-Sys     = require \./view/sys

# cannot refactor since Brfs requires this exact code format
D-About         = F.readFileSync __dirname + \/doc/about.html
T-EdgeEdit      = F.readFileSync __dirname + \/view/edge/edit.html
T-Edge          = F.readFileSync __dirname + \/view/edge.html
T-Edges         = F.readFileSync __dirname + \/view/edges.html
T-EdgesHead     = F.readFileSync __dirname + \/view/edges-head.html
T-EvidenceEdit  = F.readFileSync __dirname + \/view/evidence-edit.html
T-Evidences     = F.readFileSync __dirname + \/view/evidences.html
T-EvidencesHead = F.readFileSync __dirname + \/view/evidences-head.html
T-Latest        = F.readFileSync __dirname + \/view/latest.html
T-MapsList      = F.readFileSync __dirname + \/view/maps-list.html
T-Meta          = F.readFileSync __dirname + \/view/meta.html
T-Node          = F.readFileSync __dirname + \/view/node.html
T-NodeEdit      = F.readFileSync __dirname + \/view/node/edit.html
T-NodeEdgesA    = F.readFileSync __dirname + \/view/node/edges-a.html
T-NodeEdgesB    = F.readFileSync __dirname + \/view/node/edges-b.html
T-NoteEdit      = F.readFileSync __dirname + \/view/note-edit.html
T-Nodes         = F.readFileSync __dirname + \/view/nodes.html
T-NodesHead     = F.readFileSync __dirname + \/view/nodes-head.html
T-Notes         = F.readFileSync __dirname + \/view/notes.html
T-NotesHead     = F.readFileSync __dirname + \/view/notes-head.html
T-User          = F.readFileSync __dirname + \/view/user.html
T-UserEdit      = F.readFileSync __dirname + \/view/user/edit.html
T-UserSignin    = F.readFileSync __dirname + \/view/user/signin.html
T-UserSigninErr = F.readFileSync __dirname + \/view/user/signin-error.html
T-Users         = F.readFileSync __dirname + \/view/users.html
T-Version       = F.readFileSync __dirname + \/view/version.html

module.exports
  ..doc-about       = new Vr.DocuView document:D-About        , el:\.view>.main
  ..edge            = new Vr.InfoView template:T-Edge         , el:\.view>.main
  ..edge-a-node-sel = new Vs.SelectView                         sel:\#a_node_id
  ..edge-b-node-sel = new Vs.SelectView                         sel:\#b_node_id
  ..edge-edit       = new Ve.EditView template:T-EdgeEdit     , el:\.view>.main
  ..edges           = new Vr.ListView template:T-Edges        , el:\.view>.edges
  ..edges-head      = new Vr.InfoView template:T-EdgesHead    , el:\.view>.main
  ..evidence-edit   = new Ve.EditView template:T-EvidenceEdit , el:\.view>.evidence-edit
  ..evidences       = new Vr.ListView template:T-Evidences    , el:\.view>.evidences
  ..evidences-head  = new Vr.InfoView template:T-EvidencesHead, el:\.view>.evidences-head
  ..footer          = new V-Footer                              el:\.footer
  ..latest          = new Vr.ListView template:T-Latest       , el:\.view>.main, opts:{ fetch:true }
  ..maps            = new V-Maps                                el:\.view.maps
  ..maps-list       = new Vr.ListView template:T-MapsList     , el:\.view>.maps-list
  ..meta            = new Vr.InfoView template:T-Meta         , el:\.view>.meta
  ..navbar          = new V-NavBar                              el:\.navigator
  ..node            = new Vr.InfoView template:T-Node         , el:\.view>.main
  ..node-edit       = new Ve.EditView template:T-NodeEdit     , el:\.view>.main
  ..node-edges-a    = new Vr.ListView template:T-NodeEdgesA   , el:\.view>.node-edges-a
  ..node-edges-b    = new Vr.ListView template:T-NodeEdgesB   , el:\.view>.node-edges-b
  ..node-edges-head = new Vr.InfoView template:T-EdgesHead    , el:\.view>.node-edges-head
  ..nodes           = new Vr.ListView template:T-Nodes        , el:\.view>.nodes
  ..nodes-head      = new Vr.InfoView template:T-NodesHead    , el:\.view>.main
  ..note-edit       = new Ve.EditView template:T-NoteEdit     , el:\.view>.note-edit
  ..notes           = new Vr.ListView template:T-Notes        , el:\.view>.notes
  ..notes-head      = new Vr.InfoView template:T-NotesHead    , el:\.view>.notes-head
  ..sys             = new V-Sys                                 el:\.view>.main
  ..user            = new Vr.InfoView template:T-User         , el:\.view>.main
  ..user-edit       = new Ve.EditView template:T-UserEdit     , el:\.view>.main
  ..user-signin     = new Ve.EditView template:T-UserSignin   , el:\.view>.main
  ..user-signin-err = new Vr.InfoView template:T-UserSigninErr, el:\.view>.main, opts:{ query-string:true }
  ..user-signout    = new Vr.InfoView template:''             , el:\.view>.main
  ..user-signup     = new Ve.EditView template:T-UserEdit     , el:\.view>.main
  ..users           = new Vr.ListView template:T-Users        , el:\.view>.users, opts:{ fetch:true }
  ..version         = new Vr.InfoView template:T-Version      , el:\.view-version
