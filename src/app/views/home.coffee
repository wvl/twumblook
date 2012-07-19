

base = require '../base/index'

class Home extends base.ItemView
  initialize: ->
    @text = @options.text || "Hello Backbone Home"

  data: -> {@text}

module.exports = Home

