
module.exports = api = {}
api.users   = u    = require './users'
api.entries = e    = require './entries'
api.auth    = auth = require './auth'

api.routes =
  'users':
    get: u.list
    post: u.create
  'users/:username':
    get: u.get
    delete: [u.find, u.delete]
    put: [u.find, u.update]
  'users/:username/entries':
    get: [u.find, e.list]
  'session':
    get: auth.session
    post: auth.login
    delete: auth.logout

  # Blog api:
  'entries':
    get: e.list
    post: [auth.loggedIn, e.create]
  'entries/:id':
    get: e.get
    put: e.update
    delete: e.delete
