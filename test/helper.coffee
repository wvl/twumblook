
e = require('chai').expect
conf = require('../lib/conf')('test')
throw new Error("Env should be test!") unless conf.env == 'test'

h = {}
module.exports = {h,e,conf}

