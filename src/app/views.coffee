
backbone = require 'backbone'

class Home extends backbone.View
  initialize: ->
    @text = @options.text || "Hello Backbone"
    @render()

  render: ->
    @$el.html("<h1>#{@text}</h1>")

module.exports = Home
