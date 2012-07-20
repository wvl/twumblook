module.exports = auth = {}

base = require '../base/index'
models = require '../models'

class auth.Login extends base.FormView
  initialize: ->
    @model ?= new models.Session()

  events:
    'submit': 'handleFormSubmit'

class auth.Signup extends base.FormView
  initialize: ->
    @model ?= new models.User()

  events:
    'submit': 'handleFormSubmit'
