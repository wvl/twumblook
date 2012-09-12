module.exports = blog = {}
models = require '../models'
views = require '../views'

blog.find = (ctx, next) ->
  return next() if @store.entries[ctx.params.id]
  models.Entry.find ctx.params.id, (err, entry) =>
    @store.setIn 'entries', ctx.params.id, entry if entry
    next()

blog.dashboard = (ctx) ->
  new views.blog.Dashboard({model: @store.user})

blog.fetch = (ctx,next) ->
  return next() if ctx.user.entries.length
  success = -> next()
  ctx.user.entries.fetch({success})

blog.list = (ctx) ->
  new views.blog.Blog({model: ctx.user, collection: ctx.user.entries})

blog.newlink = (ctx) ->
  new views.blog.NewLink()

blog.newpost = (ctx) ->
  view = new views.blog.NewPost({collection: ctx.user.entries})
  view.on 'success', (post) =>
    @store.setIn 'entries', post.id, post
    @show "/blog/#{@store.user.get('username')}/#{post.id}"

blog.entry = (ctx) ->
  new views.blog.Entry({model: @store.entries[ctx.params.id]})
