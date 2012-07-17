
backbone = require 'backbone'
Home = require './views'
page = require 'page'
# jquery = require 'jquery'

module.exports = app = {}
$ = if (typeof window != 'undefined') then window.$ else null

login = ->
  console.log "login"
  new Home({el: $('#app'), text: 'Login'})

home = ->
  console.log "home"
  new Home({el: $('#app'), text: 'Home'})

page('/', home)
page('/login', login)
page.base('/app')

app.init = ->
  page()
  # home = new Home({el: $('#app')})
  console.log "Init app??"

app.render = (jq, route='/') ->
  $ = jq
  page(route)
