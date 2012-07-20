ItemView = require './item-view'
_ = require 'underscore'
require 'toObject' if (typeof window != 'undefined')

class FormView extends ItemView

FormViewMixin =
  # override for custom handling
  formToObject: -> @$('form').toObject()

  handleFormSubmit: (e) ->
    e.preventDefault()

    obj = @formToObject()

    callbacks =
      wait: true

      success: (model, resp) =>
        @trigger 'success', @model

      error: (model, resp, options) =>
        console.log "Handle error", model, resp, options
        # @error = ps.app.error("Error", resp, obj)
        @error = resp
        @rerender()

    if @collection
      @collection.create(obj, callbacks)
    else
      @model.save(obj, callbacks)

_.extend FormView.prototype, FormViewMixin

module.exports = {FormView, FormViewMixin}
