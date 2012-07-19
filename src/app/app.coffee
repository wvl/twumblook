
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
  return next() if ctx.user and ctx.user.get('username')==ctx.params.user
  console.log "Loading user: ", ctx.params.user
  models.User.find ctx.params.user, (err, user) ->
    if err
      console.log "Handle user not found"
    else
      # console.log "Result from find: ", err, user
      ctx.user = user if user
      next()

loadEntries = (ctx, next) ->
  ctx.user.entries.fetch({success: next})

profile = (ctx) ->
  # console.log "profile of: ", ctx.user
  view = new views.Profile({el: $('#app'), model: ctx.user})
  view.render()

blog = (ctx) ->
  view = new views.Blog({el: $('#app'), model: ctx.user, collection: ctx.user.entries})
  view.render()

wrap = (fn) ->
  (ctx) ->
    fn(ctx)
    ctx.state.callback() if ctx.state.callback

page.base('/app')
page('/', wrap(home))
page('/login', login)
page('/profile/:user', loadUser, wrap(profile))
page('/profile/:user/blog', loadUser, loadEntries, wrap(blog))
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
