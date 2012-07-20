{ baseUrl: 'www/js'
, optimize: 'none'
, wrap: false
, shim:
  { 'backbone': { deps: ['underscore','jquery'], exports: 'Backbone' }
  , 'underscore': { exports: '_' }
  , 'moment': { exports: 'moment' }
  , 'nct': { exports: 'nct' }
  , 'page': { exports: 'page' }
  , 'socket.io': { exports: 'io' }
  , './templates': { deps: ['nct'] }
  }
, paths:
  { 'jquery': '../../vendor/js/jquery-1.7.2.min'
  , 'underscore': '../../vendor/js/underscore-1.3.3.min'
  , 'backbone': '../../node_modules/backbone/backbone'
  , 'moment': '../../vendor/js/moment.min'
  , 'nct': '../../node_modules/nct/dist/nct'
  , 'page': '../../node_modules/page/build/page'
  , 'socket.io': '../../vendor/js/socket.io.min'
  }
, name: '../../vendor/js/almond'
, include: ['../../lib/app']
, out: 'www/js/app.js'
}
