
base = require './base/index'
models = require './models'

module.exports = collections = {}

class Entry extends base.Model

class collections.Entries extends base.Collection
  urlRoot: ':parent/entries'
  model: Entry
