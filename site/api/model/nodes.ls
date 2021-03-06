_      = require \lodash
M      = require \mongoose
Cons   = require \../../lib/model/constraints
Crud   = require \../crud
Err    = require \../error
P-Id   = require \./plugin/id
P-Meta = require \./plugin/meta

schema = new M.Schema do
  name: type:String, required:yes, match:Cons.node.name.regex
  tags: type:[String], validate:get-array-validator Cons.node.tag
  when: type:String, required:no, match:Cons.node.when.regex

schema
  ..plugin P-Id
  ..plugin P-Meta
  # TODO: refactor when mongo allows case-insensitive unique index
  # https://jira.mongodb.org/browse/SERVER-90
  ..pre \save (next) ->
    err, node <~ me.findOne name:new RegExp "^#{_.escapeRegExp @name}$" \i
    return next err if err
    return next! unless node
    return next! if node._id is @_id
    next new Err.Api "Duplicate detected: #{node.name}"

module.exports = me = Crud.set-fns (M.model \nodes schema)

function get-array-validator constraint
  -> if _.isArray it then (it.every -> constraint.regex.test it) else false
