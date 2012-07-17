
backbone = require 'backbone'

class User extends backbone.Model
  urlRoot: '/api/users'

module.exports = User
