
{User,Entry} = require '../models'


module.exports = api = {}

api.find = (req, res, next) ->
  cb = (err, user) ->
    req.user = user
    next()
  if req.params.username.length==24
    User.findById req.params.username, cb
  else
    User.findOne {username: req.params.username}, cb

api.get = (req, res) ->
  res.send req.user

api.list = (req, res) ->
  res.send []

api.create = (req, res) ->
  User.beget req.body, (err, user) ->
    return res.send(err, 422) if err
    res.send user

api.delete = (req, res) ->

api.update = (req, res) ->
