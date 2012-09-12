
fs         = require 'fs'
path       = require 'path'
express    = require 'express'
http       = require 'http'
_          = require 'underscore'
cons       = require 'consolidate'
cheerio    = require 'cheerio'
passport   = require 'passport'
highbrow   = require 'highbrow'
highbrow.setDomLibrary(cheerio)

conf       = require('./conf')()
models     = require './models'
client     = require './app'
api        = require './api'

_.underscored ?= highbrow.underscored

module.exports = app = express()

methodMap =
  create: 'post'
  update: 'put'
  delete: 'delete'
  read:   'get'

highbrow.Backbone.sync = (method, model, options) ->
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

app.configure 'test', ->
  app.use express.logger('dev')

app.configure ->
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.cookieSession({ secret: conf.sessionSecret, cookie: { maxAge: conf.sessionTimeout }})
  app.use express.methodOverride()
  app.use passport.initialize()
  app.use passport.session()
  app.use express.static(__dirname + '/../www')
  app.use app.router

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

highbrow.nct.onLoad = (name) ->
  dir = app.get('views')
  pathname = path.join(dir, name+'.nct')
  return fs.readFileSync(pathname, 'utf8') if fs.existsSync(pathname)
  pathname = path.join(dir, name+'.ncc')
  if fs.existsSync(pathname)
    return highbrow.nct.coffee.compile fs.readFileSync(pathname, 'utf8'), path.join(dir,path.dirname(name))
  return false


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

app.get '*', (req,res,next) ->
  return res.send(404) if req.path.match(/^\/(api|img|css|js)/)
  next()

vendor = JSON.parse(fs.readFileSync(path.join(__dirname,'..','package.json'))).vendor
config = conf.requireConfig({}, vendor, '/js', '/js/vendor/')
config.packages = [{name: 'app', location: 'app', main: 'index'}]
config = JSON.stringify(config)

layoutPath = path.join(__dirname, '../templates/layout.nct')

app.get "/*", (req,res) ->
  layout = fs.readFileSync(layoutPath, 'utf8')
  user = if req.user then JSON.stringify(req.user.toApi()) else "null"
  html = highbrow.nct.renderTemplate(layout, {user, env, config})
  $ = cheerio.load(html)
  client.render $, req.path, JSON.parse(user), ->
    res.send $.html()
