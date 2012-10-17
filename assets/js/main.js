require({
    paths: {
        jquery: 'libs/jquery',
        underscore: 'libs/underscore',
        backbone: 'libs/backbone/backbone',
        'backbone.iosync': 'libs/backbone/backbone.iosync',
        'backbone.iobind': 'libs/backbone/backbone.iobind',
        cs: 'libs/require/cs',
        'coffee-script': 'libs/coffee-script',
        io: '/socket.io/socket.io'
    },

    shim: {

        'underscore': {
            exports: '_'
        },


        'backbone': {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        },

        'backbone.iosync' : {
            deps: ['backbone']
        },

        'backbone.iobind' : {
            deps: ['backbone']
        }
    }

}, ['io', 'cs!app/main']);

