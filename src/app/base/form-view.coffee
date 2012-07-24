ItemView = require './item-view'
_ = require 'underscore'
require 'toObject' if (typeof window != 'undefined')

class FormView extends ItemView

server_error_message = """
There was an error communicating with the server.
"""
please_retry_message = """
Please try again in a few minutes. If the error persists,
please contact support.
"""

FormViewMixin =
  # override for custom handling
  formToObject: -> @$('form').toObject()

  # Take xhr response, and build error object
  _handleError: (res) ->
    if res.status == 401
      @trigger 'unauthorized'
      @error = {message: unauthorized_message}

    if res.status in [502,504] # bad gateway, gateway timeout
      message = server_error_message
      message += '\n' + please_retry_message
      @error = {message}

    # forbidden, not found, unprocessable entity
    if res.status in [403,404,422]
      try
        @error = if res.responseText then JSON.parse(res.responseText) else res
      catch e
        @error = {message: "Error"}

    if !res.status
      @error = res

    @error.message ?= "Error"

  onRender: ->
    @binder.bind @model, @$el if browser

  handleFormSubmit: (e) ->
    e.preventDefault()

    callbacks =
      success: (model, resp) =>
        @trigger 'success', @model

      error: (model, response, options) =>
        @_handleError(response)
        console.log "Handle error", model, response, options
        @rerender()
        @trigger 'error', @error

    @error = @model.savable()
    return @rerender() if @error

    if @collection
      @collection.create({}, callbacks)
    else
      @model.save({}, callbacks)

_.extend FormView.prototype, FormViewMixin

module.exports = {FormView, FormViewMixin}
