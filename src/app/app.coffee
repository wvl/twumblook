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

router = base.router()

module.exports = app = {}
main = null

if (typeof window != 'undefined')
  window.browser = true
  $ = window.$
  window.router = router
  window.store = store = {}
else
  global.browser = false
  store = {}
  $ = null

_.extend(store, backbone.Events)
store.users = {}
store.user = null

loadUser = (ctx,next) ->
  ctx.user = store.users[ctx.params.user]
  return next() if ctx.user
  models.User.find ctx.params.user, (err, user) ->
    return console.log "Handle user not found" if err
    store.users[ctx.params.user] = ctx.user = user
    console.log "Loaded User:", ctx.user
    next()

loadEntries = (ctx, next) ->
  ctx.user.entries.fetch({success: next})

loggedIn = (ctx, next) ->
  console.log "Logged in?", store.user
  return next() if store.user
  console.log "redirecting to home"
  page.show('/')

home      = (ctx) -> new views.Home({text: 'Home'})

login     = (ctx) ->
  view = new views.auth.Login()
  view.on 'success', (session) ->
    store.user = session.user
    page('/')

signup    = (ctx) ->
  view = new views.auth.Signup()
  view.on 'success', (user) ->
    store.user = user
    router.show('/')

profile   = (ctx) -> new views.Profile({model: ctx.user})
blog      = (ctx) -> new views.Blog({model: ctx.user, collection: ctx.user.entries})
dashboard = (ctx) -> new views.Dashboard({model: ctx.user})

show = (fn) ->
  (ctx) ->
    main.show fn(ctx)
    view

router.page '/', home
router.page '/login', login
router.page '/signup', signup

router.on 'show', (ctx, view) ->
  main.show view if view and view instanceof base.ItemView
  store.trigger 'show' if browser

# page '/', show(home)
# page '/login', show(login)
# page '/signup', show(signup)
# page '/:user/profile', loadUser, show(profile)
# page '/:user/blog', loadUser, loadEntries, show(blog)
# page '/dashboard', loggedIn, show(dashboard)
# page '*', ->
#   console.log "404 Catchall handler?"


app.init = (user) ->
  console.log "Init app", user
  store.user = new models.User(user) if user
  main = new base.RegionManager($('#app'))
  router.start ->
    store.trigger 'show'

app.sayHello = ->
  console.log "Say Hello"

app.render = (jq, route='/', user=null, callback) ->
  $ = jq
  store.user = new models.User(user) if user
  main = new base.RegionManager($('#app'))

  timeout = setTimeout (->
    console.log("Page show timeout")
    callback(new Error("page show teimeout"))
  ), 2000
  cb = (args...) ->
    clearTimeout timeout
    callback(args...)

  router.show route, cb
