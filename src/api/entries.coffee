module.exports = api = {}

api.list = (req,res) ->
  console.log "Returning entries for: ", req.user
  res.send [{_id: 'first-post', title: 'First Post', text: 'Hello World'}]
