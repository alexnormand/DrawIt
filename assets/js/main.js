require({
    paths: {
        jquery              : 'libs/jquery/jquery',
        'jquery.colorPicker': 'libs/jquery/jquery.colorPicker.min',
        'jquery.lettering'  : 'libs/jquery/jquery.lettering',
        underscore          : 'libs/underscore',
        backbone            : 'libs/backbone/backbone',
        'backbone.iosync'   : 'libs/backbone/backbone.iosync',
        'backbone.iobind'   : 'libs/backbone/backbone.iobind',
        cs                  : 'libs/require/cs',
        'coffee-script'     : 'libs/coffee-script',
        io                  : '/socket.io/socket.io',
        fastclick           : 'libs/fastclick'
    },

    shim: {

        'underscore': {
            exports: '_'
        },

        'backbone': {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        },

        'backbone.iosync': {
            deps: ['backbone']
        },

        'backbone.iobind': {
            deps: ['backbone']
        },

        'jquery.colorPicker': {
            deps: ['jquery'],
            exports: 'jQuery.fn.colorPicker'
        },

        'jquery.lettering': {
            deps: ['jquery'],
            exports: 'jQuery.fn.lettering'
        }
    }

}, ['io', 'cs!app/main']);

