mongoose = require 'mongoose'
_        = require 'underscore'
bcrypt   = require 'bcrypt'
fa       = require 'fa'
utils    = require './utils'

exports.UserSchema = UserSchema = new mongoose.Schema({
  username: {type: String, unique: true, required: true}
  email: {type: String, unique: true, required: true }
  name: String
  password: String
})
UserSchema.plugin utils.modifiedAtPlugin

UserSchema.statics.toError = (err) ->
  utils.apiError('User',err,['username','email'])

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

UserSchema.statics.beget = (params, callback) ->
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
UserSchema.statics.authenticate = (username, password, callback) ->
  @findOne {username}, (err, user) ->
    return callback(err) if err
    unless user
      return callback({
        message: 'Unknown user', 
        errors: [{field: 'username', code: 'missing', message: 'username not found'}]
      }, false)
    bcrypt.compare password, user.password, (err, match) ->
      if match
        return callback(null, user)
      else
        return callback({
          message: 'Invalid password',
          errors: [{field: 'password', code: 'invalid', message: 'Invalid password'}]
        }, false)

module.exports = User = mongoose.model('User', UserSchema)
