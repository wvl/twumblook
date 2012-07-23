
{Route,Router,Context,router} = require '../../lib/app/base/router'
e = require('chai').expect

route = (path, fns...) -> new Route(path, fns...)

describe "Route", ->
  it "should match a static route", ->
    e(route('/').match('/')).to.equal true

  it "should match a path param", ->
    e(route('/:name').match('/john').name).to.equal 'john'
    params = route('/user/:name/:action').match('/user/john/sings')
    e(params.name).to.equal 'john'
    e(params.action).to.equal 'sings'

  it "should set the default querystring to ''"
  it "should expose the query string"
  it "pathname: should set"
  it "pathname: should be without querystring"
  it "dispatcher: should ignore querystrings"

describe "Router", ->
  first = (ctx, next) ->
    ctx.first = true
    setTimeout next, 1

  it "should invoke a callback", (done) ->
    router().page('/', -> done()).show('/')

  it "should populate ctx.params", (done) ->
    router().page '/post/:slug', (ctx) ->
      e(ctx.params.slug).to.equal 'one'
      done()
    router().show '/post/one'

  it "should invoke multiple callbacks", (done) ->
    r = new Router()

    r.page '/multiple', first, (ctx) ->
      e(ctx.first).to.equal true
      ctx.first = false

    r.on 'show', (ctx, result) ->
      e(ctx.path).to.equal '/multiple'
      e(ctx.first).to.equal false
      done()

    r.show '/multiple'

  it "show should also return callback", (done) ->
    r = new Router()
    r.page '/multiple', first, ->
    r.show '/multiple', done

  it "should not follow the chain when error returned", (done) ->
    r = new Router()
    witherror = (ctx, next) -> next(404)
    r.page '/witherror', witherror, (ctx) ->
      throw new Error("Should not be reached")
    r.on 'show', -> throw new Error("Not reached")
    r.on 'error', (err,path,ctx,result) ->
      e(err).to.equal 404
      done()

    r.show '/witherror'


  it "should invoke multiple matching routes", (done) ->
    r = new Router()
    r.page '/users/:username/*', (ctx, next) ->
      ctx.user = ctx.params.username
      next()

    r.page '/users/:username', (ctx) ->
      e(ctx.user) == 'wvl'
      done()

    r.show '/users/wvl'

  it "should emit unhandled if no matching routes", (done) ->
    r = new Router()
    r.on 'unhandled', (ctx) ->
      e(ctx.path).to.equal '/unhandled'
      done()

    r.show '/unhandled'
      # (path, ctx, result) ->
      # e(path).to.equal '/unhandled'


# describe "Router", ->
#   it "should match a basic route", (done) ->
#     router().page('/',done).show('/')
