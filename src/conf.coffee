_ = require 'underscore'

configs =
  test:
    mongoDatabase: 'twumblook_test'

  production:
    mongoDatabase: 'twumblook_prod'

defaults =
  mongoDatabase: 'twumblook'
  mongoHost: 'localhost'

config = false

module.exports = (env) ->
  return config if config

  env ?= process.env.NODE_ENV
  throw new Error("Unknown environment") unless configs[env]

  config = _.extend({env}, defaults, configs[env])
  config.mongodb = "mongodb://#{config.mongoHost}/#{config.mongoDatabase}"

  config
