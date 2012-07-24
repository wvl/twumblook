
{h,e} = require '../helper'
_ = require 'underscore'
fa = require 'fa'

{Entry,User} = require '../../lib/models'

describe "Entry model", ->
  before (cb) ->
    h.remove [Entry,User], =>
      attrs = {username: 'wvl', name: 'Wayne',email: 'wayne@larsen.st', password: 'pass'}
      User.beget attrs, (err,@user) => cb()

  it "should create a post", (done) ->
    Entry.beget {text: '<p>This is my post</p>'}, @user, (err, post) ->
      e(err).to.not.exist
      e(post.text).to.include '<p>This is my post</p>'
      e(post.username).to.equal 'wvl'
      done()
