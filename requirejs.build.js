{ baseUrl: '.'
, optimize: 'none'
, wrap: false
, shim:
  { 'backbone': { deps: ['underscore','jquery'], exports: 'Backbone' }
  , 'underscore': { exports: '_' }
  , 'moment': { exports: 'moment' }
  , 'nct': { exports: 'nct' }
  , 'socket.io': { exports: 'io' }
  , './templates': { deps: ['nct'] }
  }
, paths:
  { 'jquery': 'vendor/js/jquery-1.7.2.min'
  , 'underscore': 'vendor/js/underscore-1.3.3.min'
  , 'backbone': 'node_modules/backbone/backbone'
  , 'moment': 'vendor/js/moment.min'
  , 'nct': 'vendor/js/nct'
  , 'socket.io': 'vendor/js/socket.io.min'
  }
, name: 'vendor/js/almond'
, include: ['lib/app']
, out: 'www/js/app.js'
}
