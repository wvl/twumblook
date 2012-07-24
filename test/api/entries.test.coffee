{h,e,conf} = require '../helper'
request  = require 'supertest'
{User,Entry} = require '../../lib/models'

app = require '../../lib/server'

ok = (done) ->
  (err,res) ->
    e(err).to.not.exist
    done()

get = (path) -> request(app).get('/api/'+path)
post = (path) -> request(app).post('/api/'+path)
put = (path) -> request(app).put('/api/'+path)
del = (path) -> request(app).delete('/api/'+path)

describe "Entries API", ->
  before (done) ->
    h.remove [Entry,User], =>
      attrs = {username: 'wvl', name: 'Wayne',email: 'wayne@larsen.st', password: 'pass'}
      User.beget attrs, (err,@user) => done()

  it "should return an empty list when no posts", (done) ->
    get('entries').expect(200).expect([]).end ok(done)

  it "should require login to post", (done) ->
    post('entries').send({text: "Hello World"}).expect(401).end ok(done)

  it "should create a text post", (done) ->
    req = post('entries').set('Cookie', h.cookie)
    req.send({text: "Hello World"}).expect(200).end (err, res) =>
      e(err).to.not.exist
      @id = res.body._id
      e(res.body.text).to.equal "Hello World"
      e(res.body.username).to.equal "wvl"
      done()

  it "should retrieve a post by id", (done) ->
    get("entries/#{@id}").expect(200).end (err, res) ->
      e(err).to.not.exist
      e(res.body.text).to.equal "Hello World"
      done()

