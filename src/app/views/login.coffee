
base = require '../base/index'

class Login extends base.ItemView
  id: 'view-login'
  initialize: ->
    @text = @options.text || "Hello Backbone Login"

  data: -> {@text}

module.exports = Login
