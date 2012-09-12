models   = require '../models'
highbrow = require 'highbrow'
_        = require 'underscore'
wysihtml5 = require 'wysihtml5' if highbrow.browser

module.exports = blog = {}

class blog.BlogItem extends highbrow.ItemView

class blog.Blog extends highbrow.CollectionView
  itemView: blog.BlogItem
  appendHtml: (el, html) -> @$('div.entries').append(html)

class blog.Dashboard extends highbrow.ItemView

class blog.NewLink extends highbrow.FormView

class blog.Entry extends highbrow.ItemView

class blog.NewPost extends highbrow.FormView
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

