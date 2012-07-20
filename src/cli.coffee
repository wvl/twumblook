fs     = require 'fs'
path   = require 'path'
c      = require 'commander'
up     = require 'up'
http   = require 'http'
moment = require 'moment'
sockjs = require 'sockjs'
config = require './conf'

json = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 
  'package.json')))

c.version json.version
c.option '-e --env <environment>', 'Environment'
c.option '-v --verbose', 'Verbose', false
c.option '-p --port <port>', 'Port to listen on', parseInt

# test = c.command 'test'
# test.description 'Run the test server'
# test.action ->
#   conf('test')
#   require('../test/browser/server').run()

sockJs = (httpServer) ->
  sockSrv = sockjs.createServer()
  sockSrv.on 'connection', (conn) ->
    console.log "Open connection"
    process.on 'SIGWINCH', ->
      conn.write 'reload'

  sockSrv.installHandlers(sockSrv, {prefix: 'sockjs'})

serve = c.command 'serve'
serve.description 'Run the server'
serve.action ->
  conf = config(c.env)
  srv = path.join(process.cwd(),'lib','server')
  httpServer = http.Server()
  # sockJs(httpServer)
  httpServer.listen(conf.port)
  srv = up(httpServer, srv, {numWorkers: 1, workerTimeout: 1000})
  console.log "server running on http://127.0.0.1:#{conf.port} with pid: #{process.pid}"
  pidfile = path.join(process.cwd(), 'tmp','app.pid')
  fs.writeFile pidfile, process.pid, (err) ->
    console.error "Error writing pidfile: #{pidfile}" if err
  process.on 'SIGUSR2', ->
    console.log "Reloading Server: ", moment().format("dddd, h:mm:ss a")
    srv.reload()

  # api.listen nconf.get('port')

c.parse process.argv

# log.set(level: 'debug') if c.verbose
# runServer() if c.args[0] is undefined


# worker = c.command 'worker'
# worker.description 'Run a task worker'
# worker.option '-k --kue-port <kue-port>', 'Kue Port', parseInt
# worker.action (cmd, options) ->
#   worker = require('./worker')
#   worker.run(cmd.kuePort, c)


# TODO:
# process.on 'uncaughtException', (err) ->
#   Hoptoad.notify err, ->
#     process.exit 0

