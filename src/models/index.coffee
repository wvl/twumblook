_        = require 'underscore'
conf     = require('../conf')()
mongoose = require 'mongoose'

console.log "connecting to: ", conf.mongoDatabase

mongoose.connect(conf.mongodb)
mongoose.connection.on 'error', (err) ->
  console.error err

mongoTimeout = setTimeout((->
  console.error "Could not connect to mongodb"
  process.exit(1)
), 5000)

mongoose.connection.on 'open', ->
  clearTimeout(mongoTimeout)

exports.User = require './user'
exports.Entry = require './entry'
