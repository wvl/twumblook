{e} = require '../helper'
_ = require 'underscore'
fa = require 'fa'

{User} = require '../../lib/models'

describe "User model", ->
  before (cb) ->
    User.remove {}, cb

  it "should require valid email", (done) ->
    user = new User({})
    user.validate (err) ->
      e(err).to.exist
      errors = User.toError(err).errors
      e(errors.length).to.equal 2
      e(_.pluck(errors,'resource')).to.include 'User'
      e(_.pluck(errors,'field')).to.include 'email'
      e(_.pluck(errors,'field')).to.include 'username'
      e(_.pluck(errors,'code')).to.eql ['missing_field','missing_field']
      done()

  it "should create a valid user", (done) ->
    User.createUser {username: 'jim', name: 'Jim Beam', email: 'jim@example.com', password: 'pass'}, (err, user) ->
      e(err).to.not.exist
      e(user.password.length).to.equal 60
      done()

  it "should validate unique email", (done) ->
    User.createUser {username: 'jim', name:'Jim Beam',email:'jim@example.com', password: 'pass'}, (err, user) ->
      e(err.errors.length).to.equal 2
      e(err.errors[0].field).to.equal 'username'
      e(err.errors[0].code).to.equal 'already_exists'
      e(err.errors[1].field).to.equal 'email'
      e(err.errors[1].code).to.equal 'already_exists'
      done()

  it "should authenticate the user", (done) ->
    User.authenticate 'jim', 'pass', (err, user) ->
      e(err).to.not.exist
      e(user.name).to.equal 'Jim Beam'
      done()

  it "should authenticate the user with incorrect password", (done) ->
    User.authenticate 'jim', 'nogood', (err, user) ->
      e(err).to.exist
      e(err.message).to.equal 'Invalid password'
      e(err.errors[0].field).to.equal 'password'
      e(user).to.equal false
      done()

  it "should authenticate the user with incorrect username", (done) ->
    User.authenticate 'nogood', 'nogood', (err, user) ->
      e(err).to.exist
      e(err.message).to.equal 'Unknown user'
      e(err.errors[0].field).to.equal 'username'
      e(user).to.equal false
      done()
