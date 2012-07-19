u = require './users'
e = require './entries'

module.exports =
  users:
    get: u.list
    post: u.create
  'users/:username':
    get: [u.find, u.get]
    delete: [u.find, u.delete]
    put: [u.find, u.update]
  'users/:username/entries':
    get: [u.find, e.list]
