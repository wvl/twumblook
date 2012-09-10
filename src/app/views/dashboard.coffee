
highbrow = require 'highbrow'

class Dashboard extends highbrow.ItemView
  events:
    'click .new-entry': 'newEntry'

  newEntry: ->
    page('/wayne/dashboard/new')


module.exports = Dashboard
