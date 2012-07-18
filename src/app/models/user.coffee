
base = require '../base/index'

class User extends base.Model
  urlRoot: '/api/users'

module.exports = User
