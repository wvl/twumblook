
express = require 'express'
# api     = require './api'
http    = require 'http'
cons    = require 'consolidate'

app = express()

app.engine('nct', cons.nct)
app.engine('jade', cons.jade)

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/../templates'
  app.set 'view engine', 'nct'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/../www')

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', (req,res) ->
  res.render 'index', {pageTitle: 'Hello World', msg: "woot!", usingNct: true}

app.get '/jade', (req,res) ->
  res.render 'index.jade', {pageTitle: 'Hello World', msg: "woot!", usingJade: true}

app.get '/fast', (req, res) ->
  res.send 'ok'

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on http://localhost:" + app.get('port'))
