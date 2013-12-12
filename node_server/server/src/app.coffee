express    = require 'express'
http       = require 'http'
routes     = require './scripts/routes'
{resp}     = require './scripts/response'
io         = require 'socket.io'
WebSocket  = require('ws')

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
model = {}

WebSocketServer = WebSocket.Server
ws = new WebSocketServer({port: 8080})
ws.on 'connection', (ws) ->
    console.log("connected!")

    ws.on 'message', (msg) ->
        # console.log('%d received: %s', new Date().getTime(), msg)
        msg = msg.substr(0, msg.length - 1)
        msg = msg.split(" ")
        console.log(msg)
        if msg.length == 6
          model =
            "roll_1": parseInt(msg[0])
            "pitch_1": parseInt(msg[1])
            "yaw_1": parseInt(msg[2])
            "roll_2": parseInt(msg[3])
            "pitch_2": parseInt(msg[4])
            "yaw_2": parseInt(msg[5])
    # ws.send('something')


# Socket IO
socketio = io.listen(app.listen(8888), {'log level': 1});

socketio.sockets.on 'connection', (socket) ->
  clients[socket.id] = socket
  console.log('connected! %s', socket.id)
  
  socket.emit 'connected',
    id: socket.id

  # socket.on 'calibrate', (data) ->
  #   console.log 'calibrate'


  socket.on 'disconnect', ->
    console.log 'disconnected'
    delete clients[socket.id]

respond = () ->
  for id, client of clients
    client.emit 'update', model

gameLoop = (loopCode) -> setInterval loopCode, 30
gameLoop ->
  respond()

# Heroku ports or 3000
# port = process.env.PORT || 3000
# app.listen port, ->
#     console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env

