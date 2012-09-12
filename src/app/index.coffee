_ = require 'underscore'
highbrow = require 'highbrow'
highbrow.setDomLibrary(require('jquery')) if highbrow.browser

viewModels = require './view-models'
highbrow.setViewModels(viewModels)
views = require './views'
models = require './models'
routes = require './routes'
{blog,user} = routes
require './templates' if highbrow.browser

module.exports = api = {}

# if highbrow.browser
#   require 'bootstrap-modal'
#   require 'bootstrap-dropdown'
#   require 'wysihtml'

full = (ctx,next) ->
  @layout 'full', 'layouts/full', '#app',
    '#topnav': (el) ->
      topnav = new views.chrome.TopNav({el, model: @store.user})
      @store.on 'set:user', (user) ->
        topnav.model = user
        topnav.rerender()
      topnav.on 'logout', =>
        @store.set('user', null)
        @show '/'
  next()

buildApp = ($, u) ->
  app = new highbrow.Application {$el: $('#full')}
  app.store.set 'user', new models.User(u) if u

  app.page '/', full, user.home
  app.page '/login', full, user.login
  app.page '/signup', full, user.signup

  dashboard = app.mount '/dashboard', user.loggedIn, blog.fetch, full
  dashboard.page '', blog.dashboard
  dashboard.page '/text', blog.newpost
  dashboard.page '/link', blog.newlink
  dashboard.page '/text/:id', blog.getEntry, blog.editPost
  dashboard.page '/link/:id', blog.getEntry, blog.editLink

  # blog = app.mount '/blog/:username', user.find, full
  # blog.page '', blog.list
  # blog.page '/:id', blog.find, blog.entry

  app.page '/blog/:username', full, user.find, blog.fetch, blog.list
  app.page '/blog/:username/:id', user.find, blog.find, blog.entry

  app.on 'show', (ctx, view) ->
    @display view if view and view instanceof highbrow.ItemView

# buildApp = (user) ->
#   store.set 'user', new models.User(user) if user
#   # topnav = new views.chrome.TopNav({el: $('#topnav'), model: store.user}).render()
#   # topnav.on 'logout', ->
#   #   router.show '/'
#   main = new base.RegionManager($('#app'))

api.init = (u) ->
  app = buildApp($, u)
  app.start ->

api.render = ($, route='/', u=null, callback) ->
  app = buildApp($, u)
  timeout = setTimeout (->
    callback(new Error("page show timeout"))
  ), 2000
  cb = (args...) ->
    $('#app').attr('data-ssr', 'true')
    clearTimeout timeout
    callback(args...)

  app.show route, cb
