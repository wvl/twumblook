
base = require './base/index'
collections = require './collections'

module.exports = models = {}

class models.User extends base.Model
  urlRoot: '/api/users'
  @relations:
    entries: collections.Entries
