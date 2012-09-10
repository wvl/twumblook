_ = require 'underscore'
highbrow = require 'highbrow'
highbrow.setDomLibrary(require('jquery')) if highbrow.browser

viewModels = require './view-models'
highbrow.setViewModels(viewModels)
views = require './views'
models = require './models'
routes = require './routes'
require '../templates' if highbrow.browser

module.exports = api = {}

# if highbrow.browser
#   require 'bootstrap-modal'
#   require 'bootstrap-dropdown'
#   require 'wysihtml'

buildApp = ($, user) ->
  app = new highbrow.Application({$el: $('#full')})
  app.store.set('user', new models.User(user)) if user

  app.page '/', routes.user.home
  app.page '/login', routes.user.login
  app.page '/signup', routes.user.signup

  dashboard = app.mount '/dashboard', routes.user.loggedIn
  dashboard.page '', routes.blog.dashboard
  dashboard.page '/text', routes.blog.newpost
  dashboard.page '/link', routes.blog.newlink

  # app.page '/blog/:username', routes.user.find, routes.blog.list
  # app.page '/blog/:username/:id', routes.user.find, routes.blog.find, routes.blog.entry

  app.on 'show', (ctx, view) ->
    @display view if view and view instanceof highbrow.ItemView

# buildApp = (user) ->
#   store.set 'user', new models.User(user) if user
#   # topnav = new views.chrome.TopNav({el: $('#topnav'), model: store.user}).render()
#   # topnav.on 'logout', ->
#   #   router.show '/'
#   main = new base.RegionManager($('#app'))

api.init = (user) ->
  app = buildApp($, user)
  app.start ->

api.render = ($, route='/', user=null, callback) ->
  app = buildApp($, user)
  timeout = setTimeout (->
    callback(new Error("page show timeout"))
  ), 2000
  cb = (args...) ->
    $('#app').attr('data-ssr', true)
    clearTimeout timeout
    callback(args...)

  app.show route, cb
