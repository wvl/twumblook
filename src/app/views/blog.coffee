
base = require '../base/index'

class BlogItem extends base.ItemView
  tagName: 'li'
  initialize: ->
    @template = _.underscored(@model.constructor.name)

class Blog extends base.CollectionView
  itemView: BlogItem
  appendHtml: (el, html) -> @$('ul.entries').append(html)

module.exports = Blog
