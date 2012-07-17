
backbone = require 'backbone'
nct = require 'nct'

class Profile extends backbone.View
  initialize: ->
    if browser and @$el.data('ssr')
      @$el.data('ssr', false)
    else
      @$el.attr('data-ssr', true) unless browser
      @render()

  render: ->
    @$el.html nct.render('profile', @model.attributes)

module.exports = Profile

