mongoose = require 'mongoose'
_        = require 'underscore'
bcrypt   = require 'bcrypt'
fa       = require 'fa'
utils    = require './utils'

exports.UserSchema = UserSchema = new mongoose.Schema({
  name: String
  email: {type: String, unique: true, required: true, }
  password: String
})
UserSchema.plugin utils.modifiedAtPlugin

UserSchema.statics.toError = (err) ->
  utils.apiError('User',err,['email'])

UserSchema.methods.toApi = ->
  doc = @toJSON()
  delete doc.password
  delete doc.password_confirm # shouldn't be here, but just in case
  doc

UserSchema.methods.setPassword = (password, callback) ->
  bcrypt.genSalt (err, salt) =>
    bcrypt.hash password, salt, (err, hashed) =>
      @password = hashed unless err
      callback(err, hashed)

UserSchema.statics.createUser = (params, callback) ->
  delete params.password_confirm
  errors = utils.require(params, ['name','email','password'])
  return callback({message: 'Missing field', errors}) if errors

  password = params.password
  delete params.password

  user = new User(params)
  user.setPassword password, (err) ->
    user.save (err) ->
      return callback(User.toError(err)) if err
      callback(null, user)

# authenticate email/password
# return api error object if anything fails
#
UserSchema.statics.authenticate = (params, callback) ->
  errors = utils.require(params, ['email','password'])
  return callback({message: 'Expected email and password', errors}) if errors

  @findOne {email: params.email}, (err, user) ->
    return callback(err) if err # TODO?
    unless user
      return callback({
        message: 'Unknown email address', 
        errors: [{field: 'email', code: 'missing', message: 'Email address not found'}]
      })
    bcrypt.compare params.password, user.password, (err, match) ->
      if match
        return callback(null, user)
      else
        return callback({
          message: 'Invalid password',
          errors: [{field: 'password', code: 'invalid', message: 'Invalid password'}]
        })

module.exports = User = mongoose.model('User', UserSchema)
