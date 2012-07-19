
base = require '../base/index'

class Dashboard extends base.ItemView
  events:
    'click .new-entry': 'newEntry'

  newEntry: ->
    page('/wayne/dashboard/new')


module.exports = Dashboard
