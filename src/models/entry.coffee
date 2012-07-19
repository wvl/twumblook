
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
})
EntrySchema.plugin utils.modifiedAtPlugin

module.exports = Entry = mongoose.model('Entry', EntrySchema)
