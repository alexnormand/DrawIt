express = require 'express'
http    = require 'http'
fs      = require 'fs'
stylus  = require 'stylus'
nib     = require 'nib'
io      = require 'socket.io'

app = express()
server = http.createServer(app)
io  = io.listen(server)

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session({ secret: "DrawIt as fast as possible" })
  app.use app.router
  app.use stylus.middleware(
    src: __dirname + "/assets"
    compile: (str, path) ->
      stylus(str)
        .set("filename", path)
        .set("compress", false)        
        .use(nib())
        .import "nib"       
  )
  app.use express.static __dirname + '/assets'

app.configure 'development', ->
  app.use express.errorHandler

# extend mixin
extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin        
  obj


game = 
  players: []
  currentPlayer: ""
  currentDrawing: 
    clickX    : []
    clickY    : []
    clickDrag : []


io.sockets.on 'connection',  (socket) ->  
  game.players.push socket.id unless socket.id in game.players

  # model#fetch
  socket.on 'games:read', (data, callback) ->
    game = extend game, data
    socket.emit 'games/' + data.id + ':update', game

  #model#save  
  socket.on 'games:update', (data, callback) ->  
    game = extend game, data 
    io.sockets.emit 'games/' + data.id + ':update', game

  socket.on 'disconnect', () ->
    game.players = game.players.filter (id) -> id isnt socket.id


app.get '/', (req, res) ->
  fs.createReadStream(__dirname + '/index.html').pipe res


server.listen app.get 'port'

console.log 'Server listening on port ' + app.get 'port'


