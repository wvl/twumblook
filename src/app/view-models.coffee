
base = require './base/index'

module.exports = vm = {}

class vm.User extends base.ViewModel
  @attrs ['username']

class vm.Entry extends base.ViewModel
  @attrs ['title','text']

class vm.Link extends base.ViewModel
  @attrs ['title','url']

class vm.Post extends base.ViewModel
  @attrs ['title','text']
