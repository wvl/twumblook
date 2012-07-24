module.exports = auth = {}

base = require '../base/index'
models = require '../models'

class auth.Login extends base.FormView
  initialize: ->
    @model ?= new models.Session()
    @on 'success', (session) ->
      store.set 'user', session.user

  events:
    'submit': 'handleFormSubmit'

class auth.Signup extends base.FormView
  initialize: ->
    @model ?= new models.User()
    @on 'success', (user) ->
      store.set 'user', user

  events:
    'submit': 'handleFormSubmit'
