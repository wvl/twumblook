
fs         = require 'fs'
path       = require 'path'
express    = require 'express'
api        = require './api'
http       = require 'http'
_          = require 'underscore'
cons       = require 'consolidate'
cheerio    = require 'cheerio'
nct        = require 'nct'
Backbone   = require 'backbone'
Backbone.$ = cheerio
client     = require('./app/app')
domain     = require 'domain'

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

_.each api, (routes, path) ->
  _.each routes, (fn, method) ->
    if _.isArray(fn)
      app[method] '/api/'+path, fn...
    else
      app[method] '/api/'+path, fn

app.get '/', (req,res) ->
  res.render 'index', {pageTitle: 'Hello World', msg: "woot!", usingNct: true}

nct.onLoad = (name) ->
  dir = app.get('views')
  pathname = path.join(dir, name+'.nct')
  return false unless fs.existsSync(pathname)
  fs.readFileSync pathname, 'utf8'

app.get /^\/app(\/?(.*))/, (req,res) ->
  d = domain.create()
  layout = fs.readFileSync(path.join(__dirname, '../templates/layout.nct'), 'utf8')
  html = nct.renderTemplate(layout, {})
  $ = cheerio.load(html)
  d.on 'error', (er) ->
    console.error "Caught error on domain", er
  d.run ->
    client.render $, req.path.slice(4), ->
      res.send $.html()

app.get '/jade', (req,res) ->
  res.render 'index.jade', {pageTitle: 'Hello World', msg: "woot!", usingJade: true}

app.get '/fast', (req, res) ->
  res.send 'ok'
