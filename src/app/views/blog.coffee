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
    @originalAttributes = _.clone(@model.attributes)
    @bindTo @model, 'change', =>
      @changed = _.any @model.attributes, (val,key) =>
        val!=@originalAttributes[key] and !(val=='' and !_.has(@originalAttributes, key))

  onShow: ->
    @editor = new wysihtml5.Editor("text", {
      toolbar:     @$('#wysihtml5-toolbar')[0]
      parserRules: @wysihtml5ParserRules
    })
    @editor.on 'change', -> $('#text').trigger('change')


  canNavigateAway: ->
    !@changed

  events:
    'submit': 'handleFormSubmit'

