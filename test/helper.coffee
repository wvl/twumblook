
e = require('chai').expect

module.exports = {e}
conf = require('../lib/conf')('test')

throw new Error("Env should be test!") unless conf.env == 'test'
