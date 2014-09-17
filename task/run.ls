_       = require \lodash
Assert  = require \assert
Chalk   = require \chalk
Cp      = require \child_process
Mg      = require \mongoose
Shell   = require \shelljs/global
Cfg     = require \./config
Dir     = require \./constants .dir
DirSite = require \./constants .dir.site
G       = require \./growl

Cfg.dev     <<< dirsite:DirSite.DEV
Cfg.staging <<< dirsite:DirSite.STAGING

module.exports =
  cancel           : -> kill-all-mocha ...
  loop-dev-test_2  : -> loop-dev-test_2!
  recycle-dev      : -> recycle-primary Cfg.dev
  recycle-staging  : -> recycle-primary Cfg.staging
  run-dev-test_1   : -> run-test_1 Cfg.dev
  run-dev-test_2   : -> run-test_2 Cfg.dev
  run-dev-tests    : -> run-tests Cfg.dev
  run-staging-tests: -> run-tests Cfg.staging, ' for staging'

## helpers

const GLOB_1 = 'test/_unit/**/*.js test/_integration/api.js test/_integration/api/**/*.js'
const GLOB_2 = 'test/_integration/app.js'
const RX-ERR = /(expected|error|exception)/i

function drop-db cfg, cb
  conn = Mg.createConnection cfg.WDTS_DB_URI
  e <- conn.db.executeDbCommand dropDatabase:1
  throw new Error "drop-db failed: #e" if e
  conn.close!
  cb!

function get-mocha-cmd glob, opts
  cmd = "#{Dir.DEV}/node_modules/mocha/bin/_mocha"
  "#cmd --reporter spec --bail #glob"

function get-site-desc cfg
  "#{cfg.NODE_ENV}@#{cfg.PORT}"

function get-start-site-args cfg
  "#{cfg.NODE_ARGS or ''} boot #{get-site-desc cfg}".trim!

function kill-all-mocha cb
  <- kill-mocha GLOB_1
  <- kill-mocha GLOB_2
  cb!

function kill-mocha glob, cb
  <- kill-node (get-mocha-cmd glob)
  cb!

function kill-node args, cb
  # can't use WaitFor as we need the return code
  code, out <- exec cmd = "pkill -ef 'node #{args.replace /\*/g, '\\*'}'"
  # 0 One or more processes matched the criteria. 
  # 1 No processes matched. 
  # 2 Syntax error in the command line. 
  # 3 Fatal error: out of memory etc. 
  throw new Error "#cmd returned #code" if code > 1
  cb!

function loop-dev-test_2
  <- run-test_2 Cfg.dev, ''
  loop-dev-test_2!

function recycle-primary cfg, cb
  <- stop-site cfg.primary
  <- start-site cfg.dirsite, cfg.primary
  cb! if cb?

function run-tests
  run-test_1 ...
  run-test_2 ...

function run-test_1 cfg, desc = ''
  recycle-tests cfg.test_1, cfg.tester_1, cfg.dirsite, GLOB_1, "Unit & api tests#desc"

function run-test_2 cfg, desc = '', cb
  recycle-tests cfg.test_2, cfg.tester_2, cfg.dirsite, GLOB_2, "App tests#desc", cb

function recycle-tests test, tester, dirsite, glob, desc, cb
  <- kill-mocha glob
  G.say "#desc started"
  start = Date.now!
  <- stop-site test
  <- drop-db test
  <- start-site dirsite, test
  e <- start-mocha tester, glob
  return G.err e if e?
  G.ok "#desc passed in #{(Date.now! - start)/1000}s"
  cb! if cb?

function start-mocha cfg, glob, cb
  if _.isFunction glob then [glob, cb] = [void, glob] # variadic
  v = exec 'node --version', silent:true .output.replace '\n', ''
  log "start mocha in node #v: #glob"
  cfg <<< firefox-host:env.firefox-host or \localhost
  cmd = get-mocha-cmd glob
  Cp.spawn \node, (cmd.split ' '), cwd:Dir.DEV, env:(env with cfg), stdio:[ 0, 1, void ]
    ..on \exit, ->
      cb if it then new Error "Exited with code #it" else void
    ..stderr.on \data, ->
      log s = it.toString!
      # data may be fragmented, so only growl relevant packet
      G.alert (Chalk.stripColor s), nolog:true if RX-ERR.test s

function start-site cwd, cfg, cb
  v = exec 'node --version', silent:true .output.replace '\n', ''
  desc = get-site-desc cfg
  args = get-start-site-args cfg
  log "start site in node #v: #args"
  return log "unable to start non-existent site at #cwd" unless test \-e, cwd
  Cp.spawn \node, (args.split ' '), cwd:cwd, env:env with cfg
    ..stderr.on \data, ->
      log-data s = it.toString!
      # data may be fragmented, so only growl relevant packet
      if RX-ERR.test s then G.alert "#desc\n#s", nolog:true
    ..stdout.on \data, ->
      log-data it.toString!
      cb! if cb and /listening on port/.test it

  function log-data
    log Chalk.gray "#{Chalk.underline desc} #{it.slice 0, -1}"

function stop-site cfg, cb
  args = get-start-site-args cfg
  log "stop site: #args"
  <- kill-node args
  cb!
