
e = require('chai').expect
fa = require 'fa'
conf = require('../lib/conf')('test')
throw new Error("Env should be test!") unless conf.env == 'test'

h = {}
module.exports = {h,e,conf}

h.remove = (models, callback) ->
	fa.each models, ((model, cb) ->
		model.remove {}, cb
	), callback

h.cookie = "connect.sess=s%3Aj%3A%7B%22passport%22%3A%7B%22user%22%3A%22wvl%22%7D%7D.rR4BLQI2wVILMDSX6R5B7l044aly3ir7nUm4r8KIhsw; Path=/; Expires=Thu, 24 Jul 2014 19:51:16 GMT; HttpOnly"
