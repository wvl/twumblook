_         = require 'underscore'
uuid      = require 'node-uuid'
mongoose = require 'mongoose'

# Convert a mongo error object intoan api error object
#
# Api error object consists of:
# {
#   message: 'Explanation of the error',
#   errors: [
#     {resource: 'User',
#      field:    'email',
#      code:     'required',
#      message:  'Optional message for the field error'}
#   ]
# }
# Available codes are:
#   * missing: A resource does not exist
#   * already_exists: another resource has the same value as this field.
#     This can happen in resources that must have some unique key (such as Label names).
#   * missing_field: a required field on a resource has not been set
#   * invalid: the formatting of a field is invalid.
#
exports.apiError = apiError = (resource, err, unique=[]) ->
  errors = []
  # console.log "err", err.name, _.keys(err), err
  if err?.name == "ValidationError" or err?.name == "MongoError"
    # console.log _.keys(err)
    if err.err?.match(/duplicate key/)
      dupfields =  _.filter(unique, (field) -> err.err.indexOf(field))
      errors = errors.concat _.map dupfields, (field) ->
        {resource,field,code: 'already_exists'}

    errors = errors.concat _.map (err.errors || []), (obj,field) ->
      code = if obj.type=='required' then 'missing_field' else 'invalid'
      {resource,field,code}

    return {message: "Validation Failed", errors, status: 422}
  else
    return {message: "Error: "+err?.message, status: 500}

# Expect list of fields to exist in object
exports.require = (object, required_fields) ->
  errors = _.filter required_fields, (field) -> object[field] == undefined or object[field] == ''
  if errors.length then _.map(errors, (field) -> {field, code: 'missing_field'}) else false

# Filter object to only specified fields, in place
exports.filter = (object, fields) ->
  for key,value of object
    delete object[key] unless _.include(fields, key)
  object

exports.timeAndPlace =
  location: String
  geo: [Number, Number]
  geoViewport: [Number,Number,Number,Number]
  startDate: Date
  endDate: Date

exports.uuidPlugin = (schema, options) ->
  schema.pre 'save', (next) ->
    @_id = uuid.v4() if @isNew
    next()

exports.modifiedAtPlugin = (schema, options) ->
  schema.add
    modifiedAt: {type: Date, default: Date.now}
    createdAt: {type: Date, default: Date.now}

  schema.pre 'save', (next) ->
    @modifiedAt = if @isNew then @createdAt else new Date()
    next()

  schema.path('createdAt').index(true)

