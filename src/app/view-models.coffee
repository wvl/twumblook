
highbrow = require 'highbrow'

module.exports = vm = {}

class vm.User extends highbrow.ViewModel
  @attrs ['username','name','email','password']

class vm.Session extends highbrow.ViewModel
  @attrs ['username','password']

class vm.Entry extends highbrow.ViewModel
  @attrs ['title','text']

class vm.Link extends highbrow.ViewModel
  @attrs ['title','url']

class vm.Post extends highbrow.ViewModel
  @attrs ['title','text']
