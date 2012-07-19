_ = require 'underscore'
_.underscored = (str) ->
  str.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/\-|\s+/g, '_').toLowerCase()

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

home      = (ctx) -> new views.Home({text: 'Home'})
login     = (ctx) -> new views.Login({text: 'Login'})
profile   = (ctx) -> new views.Profile({model: ctx.user})
blog      = (ctx) -> new views.Blog({model: ctx.user, collection: ctx.user.entries})
dashboard = (ctx) -> new views.Dashboard({model: ctx.user})

show = (fn) ->
  (ctx) ->
    main.show fn(ctx)
    ctx.state.callback() if ctx.state.callback

page.base('/app')
page '/', show(home)
page '/login', show(login)
page '/:user/*', loadUser
page '/:user/dashboard', show(dashboard)
page '/:user/profile', show(profile)
page '/:user/blog', loadEntries, show(blog)
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
  timeout = setTimeout (->
    console.log("Page show timeout")
    callback(new Error("page show teimeout"))
  ), 2000
  cb = (args...) ->
    clearTimeout timeout
    callback(args...)

  page.show(route, {callback: cb})
