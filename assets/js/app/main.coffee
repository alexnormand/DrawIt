define ['cs!app/views/canvas', 'cs!app/models/game', 'backbone.iosync', 'backbone.iobind'], (CanvasView, GameModel) ->

  window.socket = io.connect (location.protocol + '//' +  location.host)

  game = new GameModel({id: 1})  
  canvas = new CanvasView({ model: game })

  game.fetch()

