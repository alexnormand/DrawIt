define ['backbone', 'app/models/game'], (Backbone, GameModel) ->

  class Games extends Backbone.Collections
    model: GameModel
    url: 'games'

