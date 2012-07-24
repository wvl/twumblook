
fs         = require 'fs'
path       = require 'path'
express    = require 'express'
http       = require 'http'
_          = require 'underscore'
cons       = require 'consolidate'
cheerio    = require 'cheerio'
nct        = require 'nct'
passport   = require 'passport'
Backbone   = require 'backbone'
Backbone.$ = cheerio
bCapServer = require 'buster-capture-server'

conf       = require('./conf')()
models     = require './models'
client     = require './app/app'
api        = require './api'

module.exports = app = express()

methodMap =
  create: 'post'
  update: 'put'
  delete: 'delete'
  read:   'get'

Backbone.sync = (method, model, options) ->
  timeout = setTimeout (->
    options.error("Server Backbone.sync timeout")
  ), 2000

  url = options.url
  url ?= if _.isFunction(model.url) then model.url() else model.url
  req = {method: methodMap[method], url}
  res =
    send: (json) ->
      clearTimeout timeout
      options.success(json)
  app.router req, res, ->

app.engine('nct', cons.nct)
app.engine('jade', cons.jade)

# CORS middleware
allowCrossDomain = (req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
  res.header('Access-Control-Allow-Headers', 'Content-Type')

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/../templates'
  app.set 'view engine', 'nct'
  app.use express.favicon()

app.configure 'development', ->
  app.use express.logger('dev')

app.configure ->
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.cookieSession({ secret: conf.sessionSecret, cookie: { maxAge: conf.sessionTimeout }})
  app.use express.methodOverride()
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use express.static(__dirname + '/../www')

app.configure 'development', ->
  app.use allowCrossDomain
  app.use express.errorHandler()

api.auth.initializePassport()

_.each api.routes, (routes, path) ->
  _.each routes, (fn, method) ->
    if _.isArray(fn)
      app[method] '/api/'+path, fn...
    else
      app[method] '/api/'+path, fn

nct.onLoad = (name) ->
  dir = app.get('views')
  pathname = path.join(dir, name+'.nct')
  return false unless fs.existsSync(pathname)
  fs.readFileSync pathname, 'utf8'


app.get '/jade', (req,res) ->
  res.render 'test.jade', {pageTitle: 'Hello World', msg: "woot!", isJade: true}

app.get '/fast', (req, res) ->
  res.send 'ok'

env =
  production: conf.env == 'production'
  development: conf.env == 'development'
  test: conf.env == 'test'

if conf.env == 'test'
  app.post '/test/reset', (req, res) ->
    models.User.remove {}, ->
      res.send 'OK'

  # buster = bCapServer.createServer()
  # buster.attach(app)


app.get "/*", (req,res) ->
  layout = fs.readFileSync(path.join(__dirname, '../templates/layout.nct'), 'utf8')
  user = if req.user then JSON.stringify(req.user.toApi()) else ""
  html = nct.renderTemplate(layout, {user, env})
  if true
    res.send html
  else
    $ = cheerio.load(html)
    client.render $, req.path, req.user?.toApi(), ->
      res.send $.html()

