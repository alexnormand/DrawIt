express = require 'express'
http    = require 'http'
fs      = require 'fs'
stylus  = require 'stylus'
nib     = require 'nib'

app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
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

app.get '/', (req, res) ->
  fs.createReadStream(__dirname + '/index.html').pipe res


app.listen app.get 'port'

console.log 'Server listening on port ' + app.get 'port'


