
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

loadUser = (ctx,next) ->
  models.User.find ctx.params.user, (err, user) ->
    if err
      console.log "Handle user not found"
    else
      # console.log "Result from find: ", err, user
      ctx.user = user if user
      next()

profile = (ctx) ->
  # console.log "profile of: ", ctx.user
  new views.Profile({el: $('#app'), model: ctx.user})

wrap = (fn) ->
  (ctx) ->
    fn(ctx)
    ctx.state.callback() if ctx.state.callback

page.base('/app')
page('/', wrap(home))
page('/login', login)
page('/profile/:user', loadUser, wrap(profile))
page '*', ->
  console.log "404 Catchall handler?"

app.init = ->
  page()
  # home = new Home({el: $('#app')})
  console.log "Init app??"

app.render = (jq, route='/', callback) ->
  $ = jq
  page.show(route, {callback})
