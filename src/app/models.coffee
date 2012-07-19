
base = require './base/index'

module.exports = models = {}

class models.User extends base.Model
  urlRoot: '/api/users'
