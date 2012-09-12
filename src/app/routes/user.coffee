
module.exports = user = {}
models = require '../models'
views = require '../views'

#
# Middleware
#

user.find = (ctx,next) ->
  ctx.user = @store.users?[ctx.params.username]
  return next() if ctx.user
  models.User.find ctx.params.username, (err, user) =>
    return console.log "Handle user not found" if err
    ctx.user = user
    @store.setIn('users', ctx.params.username, user)
    next()

user.loggedIn = (ctx, next) ->
  ctx.user = @store.user
  return next() if @store.user
  @show '/login', {returnTo: ctx.path}

#
# Routes
#

user.home      = (ctx) -> new views.Home({text: 'Home'})

user.login     = (ctx) ->
  view = new views.auth.Login()
  view.on 'success', (session) =>
    @store.set 'user', session.user
    @show ctx.state.returnTo || '/'

user.signup    = (ctx) ->
  view = new views.auth.Signup()
  view.on 'success', (user) =>
    @store.set 'user', user
    @show('/')

user.profile   = (ctx) -> new views.Profile({model: ctx.user})

