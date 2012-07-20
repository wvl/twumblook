{h,e,conf} = require '../helper'
request  = require 'supertest'
models = require '../../lib/models'

app = require '../../lib/server'

ok = (done) ->
  (err,res) ->
    e(err).to.not.exist
    done()

get = (path) -> request(app).get('/api/'+path)
post = (path) -> request(app).post('/api/'+path)
put = (path) -> request(app).put('/api/'+path)
del = (path) -> request(app).delete('/api/'+path)

describe "Auth API", ->
  before (done) ->
    @user =
      username: 'wvl'
      name: 'Wayne'
      email: 'wayne@larsen.st'
      password: 'pass'
    models.User.remove {}, done

  it "should return null session when not logged in", (done) ->
    get('session').expect(200).expect('').end ok(done)

  it "should create a user", (done) ->
    post('users').send(@user).expect(200).end ok(done)

  it "should authenticate with valid params", (done) ->
    req = post('session').send({username: 'wvl', password: 'pass'})
    req.expect(200).end (err, res) =>
      e(err).to.not.exist
      e(res.body.username).to.equal 'wvl'
      e(res.body.password).to.not.exist
      @cookie = res.header['set-cookie']
      done()
    
  it "should return unknown user", (done) ->
    req = post('session').send({username: 'unknown', password: 'pass'})
    req.expect(422).end (err, res) ->
      e(err).to.not.exist
      e(res.body.message).to.equal 'Unknown user'
      done()

  it "should return invalid password", (done) ->
    req = post('session').send({username: 'wvl', password: 'oops'})
    req.expect(422).end (err, res) ->
      e(err).to.not.exist
      e(res.body.message).to.equal 'Invalid password'
      done()

  it "should return an authenticated user with session cookie", (done) ->
    get('session').set('Cookie', @cookie).end (err, res) ->
      e(res.body.username).to.equal 'wvl'
      done()
