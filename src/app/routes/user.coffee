
module.exports = user = {}
models = require '../models'
views = require '../views/index'

user.loadUser = (ctx,next) ->
  ctx.user = store.users[ctx.params.user]
  return next() if ctx.user
  models.User.find ctx.params.user, (err, user) ->
    return console.log "Handle user not found" if err
    store.users[ctx.params.user] = ctx.user = user
    console.log "Loaded User:", ctx.user
    next()

user.loggedIn = (ctx, next) ->
  console.log "Logged in?", store.user
  return next() if store.user
  console.log "redirecting to home"
  router.show('/login')

user.home      = (ctx) -> new views.Home({text: 'Home'})

user.login     = (ctx) ->
  view = new views.auth.Login()
  view.on 'success', -> router.show('/')

user.signup    = (ctx) ->
  view = new views.auth.Signup()
  view.on 'success', (user) -> router.show('/')

user.profile   = (ctx) -> new views.Profile({model: ctx.user})

