express    = require 'express'
http       = require 'http'
routes     = require './scripts/routes'
{resp}     = require './scripts/response'
io         = require 'socket.io'

app = module.exports = express.createServer()

# Configuration
app.configure ->
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    # app.use express.favicon(__dirname + '/../../client/gen/assets/images/favicon.ico')
    app.use(express.static(__dirname + '/../../client/gen'))

app.configure 'development', ->
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
    app.use(express.errorHandler())

# TODO make authentication function
# authenticate = (req, res, next) ->
#     next()

# Routes
app.get '/', routes.index
app.get '*', (req, res) -> resp.error res, resp.NOT_FOUND


# clients
clients = {}

# Socket IO
io.listen(app.listen(8080), {'log level': 1}).sockets.on 'connection', (socket) ->
  clients[socket.id] = socket
  
  
  socket.emit 'connected',
    id: socket.id
    # contents:

  socket.on 'key', (data) ->
    data.id = socket.id


  socket.on 'disconnect', ->
    delete clients[socket.id]


# Heroku ports or 3000
# port = process.env.PORT || 3000
# app.listen port, ->
#     console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env

