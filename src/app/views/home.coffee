

highbrow = require 'highbrow'

module.exports = class Home extends highbrow.ItemView
  initialize: ->
    @text = @options.text || "Hello Backbone Home"

  data: -> {@text}

