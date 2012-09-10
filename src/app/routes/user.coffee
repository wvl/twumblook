
module.exports = user = {}
models = require '../models'
views = require '../views'

user.find = (ctx,next) ->
  ctx.user = @store.users[ctx.params.username]
  return next() if ctx.user
  models.User.find ctx.params.username, (err, user) =>
    return console.log "Handle user not found" if err
    @store.users[ctx.params.username] = ctx.user = user
    console.log "Loaded User:", ctx.user
    next()

user.loggedIn = (ctx, next) ->
  console.log "Logged in?", @store.user
  return next() if @store.user
  console.log "redirecting to home"
  @show('/login')

user.home      = (ctx) -> new views.Home({text: 'Home'})

user.login     = (ctx) ->
  view = new views.auth.Login()
  view.on 'success', (session) =>
    @store.set 'user', session.user
    @show '/'

user.signup    = (ctx) ->
  view = new views.auth.Signup()
  view.on 'success', (user) =>
    @store.set 'user', user
    @show('/')

user.profile   = (ctx) -> new views.Profile({model: ctx.user})

