
base = require '../base/index'

class Login extends base.ItemView
  initialize: ->
    @text = @options.text || "Hello Backbone Login"

  data: -> {@text}

module.exports = Login
