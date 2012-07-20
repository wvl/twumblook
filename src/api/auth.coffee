
passport = require 'passport'
local      = require 'passport-local'
{User} = require '../models'

module.exports = api = {}

api.initializePassport = ->
  passport.serializeUser (user, done) -> done(null, user._id)
  passport.deserializeUser (id, done) -> User.findById id, done

  passport.use new local.Strategy (username, password, done) ->
    User.authenticate username, password, (err, user) ->
      return done(err) if err and user==undefined
      return done(null, false, err) if err and user==false
      done(null, user.toApi())

# login: email/password creates a session
api.login = (req,res,next) ->
  passport.authenticate('local', ((err,user,info) ->
    return res.send err, 500 if err
    return res.send info, 422 if user==false

    req.logIn user, ->
    res.send user

  ))(req,res,next)


# logout
api.logout = (req, res) ->
  req.logOut()
  res.send {}

api.session = (req, res) ->
  res.send req.user
