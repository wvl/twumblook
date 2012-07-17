
require '../templates'
backbone = require 'backbone'
views = require './views/index'
page = require 'page'

module.exports = app = {}

if (typeof window != 'undefined')
  window.browser = true
  $ = window.$
else
  global.browser = false
  $ = null

login = ->
  console.log "login"
  new views.Login({el: $('#app'), text: 'Login'})

home = ->
  console.log "home"
  new views.Home({el: $('#app'), text: 'Home'})

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
