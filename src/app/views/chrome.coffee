base = require '../base/index'
models = require '../models'

module.exports = chrome = {}

class chrome.TopNav extends base.ItemView
  initialize: ->
    @session = new models.Session({_id: 'set', user: @model})
    store.on 'set:user', (user) =>
      @model = user
      @session = new models.Session({_id: 'set', user})
      @rerender()

  events: ->
    'click .logout': 'logout'

  logout: ->
    success = =>
      store.set 'user', null
      @trigger 'logout'
    @session.destroy({success})
