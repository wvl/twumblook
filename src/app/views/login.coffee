
backbone = require 'backbone'
nct = require 'nct'

class Login extends backbone.View
  initialize: ->
    @text = @options.text || "Hello Backbone Login"
    if browser and @$el.data('ssr')
      console.log "skipping render"
      @$el.data('ssr', false)
    else
      @$el.attr('data-ssr', true) unless browser
      console.log "rendering"
      @render()

  render: ->
    @$el.html nct.render('login', {@text})

module.exports = Login
