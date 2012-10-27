define [
  'cs!app/views/canvas',
  'cs!app/models/game',
  'fastclick',
  'backbone.iosync',
  'backbone.iobind',
  'jquery.colorPicker'
  ], (CanvasView, GameModel, Fastclick) ->

  window.socket = io.connect (location.protocol + '//' +  location.host)
  $('button').each ->
    new Fastclick(this)

  game = new GameModel({id: 1})
  canvas = new CanvasView({ model: game })

  game.fetch()

