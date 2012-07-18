
module.exports = api = {}

api.findUser = (req, res, next) ->
  req.user = {name: 'Wayne', username: 'wvl'}
  next()

api.getUser = (req, res) ->
  res.send req.user

api.listUsers = (req, res) ->
  res.send []

api.createUser = (req, res) ->

api.deleteUser = (req, res) ->

api.updateUser = (req, res) ->
