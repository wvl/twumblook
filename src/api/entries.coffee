{Entry} = require '../models'

module.exports = api = {}

api.list = (req,res) ->
  # console.log "Returning entries for: ", req.user
  # res.send {_id: 'first-post', type: 'post', title: 'First Post', text: 'Hello World'}]
  Entry.find {}, (err, entries) ->
    res.send entries

api.get = (req, res) ->
  Entry.findById req.params.id, (err, entry) ->
    res.send entry

api.create = (req, res) ->
  Entry.beget req.body, req.user, (err, entry) ->
    res.send entry

api.update = (req, res) ->

api.delete = (req, res) ->
