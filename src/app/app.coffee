_ = require 'underscore'
_.underscored = (str) ->
  str.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/\-|\s+/g, '_').toLowerCase()

require '../templates'
backbone = require 'backbone'
base = require './base/index'
viewModels = require './view-models'
base.setViewModels(viewModels)
views = require './views'
models = require './models'
routes = require './routes'

module.exports = app = {}
main = null

class Store
  constructor: ->
    @users = {}
    @entries = {}
    @user = null

  set: (name, value) ->
    @[name] = value
    @trigger 'set', name, value
    @trigger 'set:'+name, value

_.extend Store.prototype, backbone.Events

if (typeof window != 'undefined')
  window.browser = true
  $ = window.$
  window.router = router = base.router()
  window.store = store = new Store()
else
  global.browser = false
  global.router = router = base.router()
  global.store = store = new Store()
  $ = null



{blog,user} = routes

router.page '/', user.home
router.page '/login', user.login
router.page '/signup', user.signup
router.page '/dashboard/*', user.loggedIn
router.page '/dashboard', blog.dashboard
router.page '/dashboard/text', blog.newpost
router.page '/dashboard/link', blog.newlink
# router.page '/:username/:id', user.find, blog.find, blog.entry

router.on 'show', (ctx, view) ->
  main.show view if view and view instanceof base.ItemView
  store.trigger 'show', ctx, view if browser

# page '/', show(home)
# page '/login', show(login)
# page '/signup', show(signup)
# page '/:user/profile', loadUser, show(profile)
# page '/:user/blog', loadUser, loadEntries, show(blog)
# page '/dashboard', loggedIn, show(dashboard)
# page '*', ->
#   console.log "404 Catchall handler?"

buildApp = (user) ->
  store.set 'user', new models.User(user) if user
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
