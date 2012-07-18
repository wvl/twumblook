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
      e(errors.length).to.equal 1
      e(_.pluck(errors,'resource')).to.include 'User'
      e(_.pluck(errors,'field')).to.include 'email'
      e(_.pluck(errors,'code')).to.eql ['missing_field']
      done()

  it "should create a valid user", (done) ->
    User.createUser {name: 'Jim Beam', email: 'jim@example.com', password: 'pass'}, (err, user) ->
      e(err).to.not.exist
      e(user.password.length).to.equal 60
      done()

  it "should validate unique email", (done) ->
    User.createUser {name:'Jim Beam',email:'jim@example.com', password: 'pass'}, (err, user) ->
      e(err.errors.length).to.equal 1
      e(err.errors[0].field).to.equal 'email'
      e(err.errors[0].code).to.equal 'already_exists'
      done()

  it "should authenticate the user", (done) ->
    params = {email: 'jim@example.com', password: 'pass'}
    User.authenticate params, (err, user) ->
      e(err).to.not.exist
      e(user.name).to.equal 'Jim Beam'
      done()

  it "should authenticate the user with incorrect password", (done) ->
    params = {email: 'jim@example.com', password: 'nogood'}
    User.authenticate params, (err, user) ->
      e(err).to.exist
      e(err.message).to.equal 'Invalid password'
      e(err.errors[0].field).to.equal 'password'
      e(user).to.not.exist
      done()

  it "should authenticate the user with incorrect email", (done) ->
    params = {email: 'nogood@example.com', password: 'nogood'}
    User.authenticate params, (err, user) ->
      e(err).to.exist
      e(err.message).to.equal 'Unknown email address'
      e(err.errors[0].field).to.equal 'email'
      e(user).to.not.exist
      done()
