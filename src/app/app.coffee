
require '../templates'
backbone = require 'backbone'
base = require './base/index'
viewModels = require './view-models'
base.setViewModels(viewModels)
views = require './views/index'
models = require './models'
page = require 'page'

module.exports = app = {}
main = null

if (typeof window != 'undefined')
  window.browser = true
  $ = window.$
else
  global.browser = false
  $ = null

login = (ctx) ->
  console.log "login"
  main.show new views.Login({text: 'Login'})
  ctx.state.callback() if ctx.state.callback

home = (ctx) ->
  console.log "home"
  view = new views.Home({el: $('#app'), text: 'Home'})
  view.render()

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
  view = new views.Profile({el: $('#app'), model: ctx.user})
  view.render()

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
  main = new base.RegionManager($('#app'))
  page()
  # home = new Home({el: $('#app')})
  console.log "Init app??"

app.render = (jq, route='/', callback) ->
  $ = jq
  main = new base.RegionManager($('#app'))
  page.show(route, {callback})
