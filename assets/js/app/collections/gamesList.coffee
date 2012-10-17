define ['backbone', 'app/models/game'], (Backbone, GameModel) ->

  class GamesList extends Backbone.Collections
    model: GameModel
    url: 'games'

