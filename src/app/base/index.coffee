
module.exports = base = {}
base.Model = require './models'
base.ItemView = require './item-view'
base.ViewModel = require './view-model'

base.setViewModels = (viewModels) ->
  base.ItemView.viewModels = viewModels
