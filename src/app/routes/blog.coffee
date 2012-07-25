module.exports = blog = {}
models = require '../models'
views = require '../views'

blog.find = (ctx, next) ->
  return next() if store.entries[ctx.params.id]
  models.Entry.find ctx.params.id, (err, entry) ->
    store.entries[ctx.params.id] = entry if entry
    next()

blog.dashboard = (ctx) -> new views.blog.Dashboard({model: store.user})

blog.list = (ctx) ->
  new views.blog.Blog({model: ctx.user, collection: ctx.user.entries})

blog.newlink = (ctx) ->
  new views.blog.NewLink()

blog.newpost = (ctx) ->
  view = new views.blog.NewPost()
  view.on 'success', (post) ->
    store.entries[post.id] = post
    router.show "/blog/#{ctx.user.get('username')}/#{post.id}"

blog.entry = (ctx) ->
  new views.blog.Entry({model: store.entries[ctx.params.id]})
