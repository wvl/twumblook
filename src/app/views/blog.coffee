
base = require '../base/index'

class BlogItem extends base.ItemView
	tagName: 'li'

class Blog extends base.CollectionView
	itemView: BlogItem

module.exports = Blog
