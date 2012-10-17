define ['backbone', 'io'], (Backbone) ->


  class Game extends Backbone.Model
    socket: window.socket
    urlRoot: 'games' 


    initialize: () ->
      _.bindAll @, 'serverChange'
      
      @ioBind 'update', @serverChange, @


    serverChange: (data) ->
      @set data
      console.log @toJSON()







