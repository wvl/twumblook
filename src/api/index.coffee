u = require './users'

module.exports =
  users:
    get: u.listUsers
    post: u.createUser
  'users/:name':
    get: [u.findUser, u.getUser]
    delete: [u.findUser, u.deleteUser]
    put: [u.findUser, u.updateUser]
