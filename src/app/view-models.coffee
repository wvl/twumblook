
base = require './base/index'

module.exports = vm = {}

class vm.User extends base.ViewModel
  @attrs ['username']
