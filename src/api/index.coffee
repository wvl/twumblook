u = require './users'

module.exports =
  users:
    get: u.list
    post: u.create
  'users/:name':
    get: [u.find, u.get]
    delete: [u.find, u.delete]
    put: [u.find, u.update]
