
require '../templates'
backbone = require 'backbone'
views = require './views/index'
models = require './models/index'
page = require 'page'

module.exports = app = {}

if (typeof window != 'undefined')
  window.browser = true
  $ = window.$
else
  global.browser = false
  $ = null

login = (ctx) ->
  console.log "login"
  new views.Login({el: $('#app'), text: 'Login'})
  ctx.state.callback() if ctx.state.callback

home = (ctx) ->
  console.log "home"
  new views.Home({el: $('#app'), text: 'Home'})
  ctx.state.callback() if ctx.state.callback

loadUser = (ctx,next) ->
  ctx.u = new models.User({id: ctx.params.user})
  ctx.u.fetch({success: next})
  # console.log ctx.params.user
  # setTimeout (->
  #   console.log "loaded user"
  #   next()
  # ), 2000

profile = (ctx) ->
  console.log "profile of: ", ctx.u
  new views.Profile({el: $('#app'), model: ctx.u})
  ctx.state?.callback()

page.base('/app')
page '*', (ctx,next) ->
  console.log "Catchall handler?"
  next()
page('/', home)
page('/login', login)
page('/profile/:user', loadUser, profile)
page '*', ->
  console.log "404 Catchall handler?"

app.init = ->
  page()
  # home = new Home({el: $('#app')})
  console.log "Init app??"

app.render = (jq, route='/', callback) ->
  $ = jq
  page.show(route, {callback})
