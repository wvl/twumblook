
module.exports = api = {}

api.find = (req, res, next) ->
  req.user = {name: 'Wayne', username: 'wvl'}
  next()

api.get = (req, res) ->
  res.send req.user

api.list = (req, res) ->
  res.send []

api.create = (req, res) ->

api.delete = (req, res) ->

api.update = (req, res) ->
