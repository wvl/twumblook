Backbone = require 'backbone'
_ = require 'underscore'
nct      = require 'nct'
underscored = (str) ->
  str.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/\-|\s+/g, '_').toLowerCase()

# A single item view implementation that contains code for rendering
# and calling several methods on extended views, such as `onRender`.
class ItemView extends Backbone.View
  constructor:  ->
    super
    @template ?= @options.template
    @namespace = @options.namespace if @options.namespace
    @workflow ?= @options.workflow
    unless @template
      name = underscored(@constructor.name)
      @template = if @namespace then @namespace + '/' + name else name

  # override to specify title,subtitle,subnav
  view: {}

  data: ->
    return {} unless @model
    viewModel = @viewModel || ItemView.viewModels[@model.constructor.name]
    if viewModel then new viewModel(@model, @error) else @model

  context: ->
    viewdata = if _.isFunction(@view) then @view() else @view
    ctx = new nct.Context(_.extend({@workflow}, viewdata))
    ctx.push(@data())

  renderTemplate:  ->
    return unless @template
    if browser and @$el.data('ssr')
      console.log "skipping render", @template
      @$el.data('ssr', false)
    else
      @$el.attr('data-ssr', true) unless browser
      @$el.html nct.render(@template, @context())
      console.log "rendered", @template

  # Render the view with nct templates
  # You can override this in your view definition.
  render: ->
    @renderTemplate()
    @onRender()
    @

  # rerender can be passed to event bindings, as it ignores arguments
  rerender: ->
    @$el.empty()
    @render()

  # Override for post render customization
  onRender: ->

  # Override for custom close code
  onClose: ->

  # Default `close` implementation, for removing a view from the
  # DOM and unbinding it. Region managers will call this method
  # for you. You can specify an `onClose` method in your view to
  # add custom code that is called after the view is closed.
  close: ->
    @unbindAll() # bindto events
    @unbind()    # custom view events
    if @attached then @$el.empty() else @remove()    # remove el from DOM (and DOM events)
    @onClose()   # custom cleanup code


module.exports = ItemView
