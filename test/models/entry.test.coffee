
{e} = require '../helper'
_ = require 'underscore'
fa = require 'fa'

{Entry} = require '../../lib/models'

describe "Entry model", ->
  before (cb) ->
    Entry.remove {}, cb

  it "should create a post", (done) ->
    Entry.create {text: '<p>This is my post</p>'}, (err, post) ->
      e(err).to.not.exist
      e(post.text).to.include '<p>This is my post</p>'
      done()
