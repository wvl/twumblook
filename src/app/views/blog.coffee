models = require '../models'
base = require '../base/index'
module.exports = blog = {}

class blog.BlogItem extends base.ItemView
  tagName: 'li'
  initialize: ->
    @template = _.underscored(@model.constructor.name)

class blog.Blog extends base.CollectionView
  itemView: blog.BlogItem
  appendHtml: (el, html) -> @$('ul.entries').append(html)

class blog.Dashboard extends base.ItemView

class blog.NewLink extends base.FormView

class blog.Entry extends base.ItemView

class blog.NewPost extends base.FormView
  initialize: ->
    @model ?= new models.Post()

  events:
    'submit': 'handleFormSubmit'

