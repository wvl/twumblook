
highbrow = require 'highbrow'

module.exports = models = {}
models.collections = collections = {}

class models.Entry extends highbrow.Model
class models.Link extends models.Entry
class models.Post extends models.Entry
  validations:
    required: ['text']

class collections.Entries extends highbrow.Collection
  urlRoot: ':parent/entries'
  model: (attrs, options) ->
    switch attrs.type
      when 'link' then new models.Link(attrs, options)
      when 'post' then new models.Post(attrs, options)
      else new models.Entry(attrs, options)

class models.User extends highbrow.Model
  urlRoot: '/api/users'
  @relations:
    entries: collections.Entries

  validations:
    required: ['username','name','email']

  savable: ->
    e = super || {message: 'Validation Failed', errors: []}
    if @isNew() and !@get('password')
      e.errors.push({field: 'password', code: 'missing_field'})

    if e.errors.length then e else null

class models.Session extends highbrow.Model
  url: '/api/session'
  validations:
    required: ['username','password']

  @relations:
    user: models.User

