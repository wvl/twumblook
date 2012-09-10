

highbrow = require 'highbrow'

class Home extends highbrow.ItemView
  initialize: ->
    @text = @options.text || "Hello Backbone Home"

  data: -> {@text}

module.exports = Home

