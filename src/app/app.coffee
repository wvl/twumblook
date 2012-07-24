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

class Store
  constructor: ->
    @users = {}
    @user = null

  set: (name, value) ->
    @[name] = value
    @trigger 'set', name, value
    @trigger 'set:'+name, value

_.extend Store.prototype, backbone.Events

if (typeof window != 'undefined')
  window.browser = true
  $ = window.$
  window.router = router
  window.store = store = new Store()
else
  global.browser = false
  store = new Store()
  $ = null

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
  view.on 'success', -> router.show('/')

signup    = (ctx) ->
  view = new views.auth.Signup()
  view.on 'success', (user) -> router.show('/')

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

buildApp = (user) ->
  store.set 'user', new models.User(user)
  topnav = new views.chrome.TopNav({el: $('#topnav'), model: store.user}).render()
  topnav.on 'logout', ->
    router.show '/'
  main = new base.RegionManager($('#app'))

app.init = (user) ->
  buildApp(user)
  router.start ->
    store.trigger 'show'

app.render = (jq, route='/', user=null, callback) ->
  $ = jq
  buildApp(user)
  timeout = setTimeout (->
    callback(new Error("page show timeout"))
  ), 2000
  cb = (args...) ->
    $('#app').attr('ssr', true)
    clearTimeout timeout
    callback(args...)

  router.show route, cb
