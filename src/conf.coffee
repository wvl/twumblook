_ = require 'underscore'

configs =
  test:
    mongoDatabase: 'twumblook_test'

  production:
    mongoDatabase: 'twumblook_prod'
    port: 3000

  development:
    port: 3000

defaults =
  sessionSecret: 'ljkzmYzkUmtmSgDPKVpXghJnYsIMMWHcZbJcfmEotoz7GZw6Ne'
  sessionTimeout: 2 * 365 * 1000 * 60 * 60 * 24  # 2 years
  mongoDatabase: 'twumblook'
  mongoHost: 'localhost'

config = false

module.exports = (env) ->
  return config if config

  env ?= process.env.NODE_ENV || 'development'
  throw new Error("Unknown environment: #{env}") unless configs[env]
  process.env.NODE_ENV ?= env

  config = _.extend({env}, defaults, configs[env])
  config.mongodb = "mongodb://#{config.mongoHost}/#{config.mongoDatabase}"

  config
