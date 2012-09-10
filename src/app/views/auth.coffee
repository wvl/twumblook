module.exports = auth = {}

highbrow = require 'highbrow'
models = require '../models'

class auth.Login extends highbrow.FormView
  initialize: ->
    @model ?= new models.Session()

  events:
    'submit': 'handleFormSubmit'

class auth.Signup extends highbrow.FormView
  initialize: ->
    @model ?= new models.User()

  events:
    'submit': 'handleFormSubmit'
