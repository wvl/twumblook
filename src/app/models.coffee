
base = require './base/index'
collections = require './collections'

module.exports = models = {}

class models.User extends base.Model
  urlRoot: '/api/users'
  @relations:
    entries: collections.Entries

  validations:
    required: ['username','name','email']

  validate: (attrs) ->
    e = super || {message: 'Validation Failed', errors: []}
    if @isNew() and !attrs._id and !attrs.password
      e.errors.push({field: 'password', code: 'missing_field'})

    if e.errors.length then e else null

class models.Session extends base.Model
  url: '/api/session'
  validations:
    required: ['username','password']

  @relations:
    user: models.User

