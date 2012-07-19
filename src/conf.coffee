_ = require 'underscore'

configs =
  test:
    mongoDatabase: 'twumblook_test'

  production:
    mongoDatabase: 'twumblook_prod'

  development:
    port: 3000

defaults =
  mongoDatabase: 'twumblook'
  mongoHost: 'localhost'

config = false

module.exports = (env) ->
  return config if config

  env ?= process.env.NODE_ENV || 'development'
  throw new Error("Unknown environment: #{env}") unless configs[env]

  config = _.extend({env}, defaults, configs[env])
  config.mongodb = "mongodb://#{config.mongoHost}/#{config.mongoDatabase}"

  config
