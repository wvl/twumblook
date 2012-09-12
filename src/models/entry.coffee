
mongoose = require 'mongoose'
_        = require 'underscore'
fa       = require 'fa'
utils    = require './utils'

exports.EntrySchema = EntrySchema = new mongoose.Schema({
  title: String
  text: String
  caption: String
  quote: String
  source: String
  url: String
  username: String
})
EntrySchema.plugin utils.modifiedAtPlugin

EntrySchema.statics.beget = (params,user,callback) ->
  # validate params
  params.username = user.username
  Entry.create params, (err, entry) ->
    return callback(Entry.toError(err)) if err
    callback(null, entry)

module.exports = Entry = mongoose.model('Entry', EntrySchema)
