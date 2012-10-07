require({
    paths: {
        jquery: 'libs/jquery',
        underscore: 'libs/underscore',
        backbone: 'libs/backbone',
        cs: 'libs/require/cs',
        'coffee-script': 'libs/coffee-script'
    },


    shim: {
        'backbone': {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        }
    }

}, ['cs!csmain']);

