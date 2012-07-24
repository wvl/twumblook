_ = require 'underscore'

configs =
  test:
    mongoDatabase: 'twumblook_test'
    port: 3405

  production:
    port: 3410
    mongoDatabase: 'twumblook_prod'

  development:
    port: 3400


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
