
base = require './base/index'
models = require './models'

module.exports = collections = {}

class Entry extends base.Model
class Link extends Entry
class Post extends Entry

class collections.Entries extends base.Collection
  urlRoot: ':parent/entries'
  model: (attrs, options) ->
    switch attrs.type
      when 'link' then new Link(attrs, options)
      when 'post' then new Post(attrs, options)
