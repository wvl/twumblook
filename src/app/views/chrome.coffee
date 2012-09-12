highbrow = require 'highbrow'
models = require '../models'

module.exports = chrome = {}

class chrome.TopNav extends highbrow.ItemView
  initialize: ->
    @session = new models.Session({_id: 'set', user: @model})
    # store.on 'set:user', (user) =>
    #   @model = user
    #   @session = new models.Session({_id: 'set', user})
    #   @rerender()

  events: ->
    'click .logout': 'logout'

  logout: (e) ->
    e.preventDefault()
    success = =>
      @trigger 'logout'
    @session.destroy({success})
