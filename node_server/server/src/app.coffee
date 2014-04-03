express    = require 'express'
http       = require 'http'
routes     = require './scripts/routes'
{resp}     = require './scripts/response'
io         = require 'socket.io'
WebSocket  = require('ws')
{storage}  = require './scripts/storage'
{model}    = require './scripts/model'

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
app.get '/download', (req, res) ->
  file = 'recordings/' + req.query.n
  res.download(file)
app.get '*', (req, res) -> resp.error res, resp.NOT_FOUND


# clients
clients = {}

WebSocketServer = WebSocket.Server
ws = new WebSocketServer({port: 8080})
ws.on 'connection', (ws) ->
    console.log("connected!")

    ws.on 'message', (msg) ->
        # console.log('%d received: %s', new Date().getTime(), msg)
        msg = msg.substr(0, msg.length - 1)
        msg = msg.split(" ")
        if msg.length >= 18
          m =
            "roll_1": parseInt(msg[0])
            "pitch_1": parseInt(msg[1])
            "yaw_1": parseInt(msg[2])
            "roll_2": parseInt(msg[3])
            "pitch_2": parseInt(msg[4])
            "yaw_2": parseInt(msg[5])
            "roll_r_1": parseInt(msg[6])
            "pitch_r_1": parseInt(msg[7])
            "yaw_r_1": parseInt(msg[8])
            "roll_r_2": parseInt(msg[9])
            "pitch_r_2": parseInt(msg[10])
            "yaw_r_2": parseInt(msg[11])
            "accelx_1": parseInt(msg[12])
            "accely_1": parseInt(msg[13])
            "accelz_1": parseInt(msg[14])
            "accelx_2": parseInt(msg[15])
            "accely_2": parseInt(msg[16])
            "accelz_2": parseInt(msg[17])
          model.update(m, new Date().getTime())
          storage.store model.data(), new Date().getTime()
    # ws.send('something')

# Socket IO
socketio = io.listen(app.listen(8888), {'log level': 1});

socketio.sockets.on 'connection', (socket) ->
  clients[socket.id] = socket
  console.log('connected! %s', socket.id)
  
  socket.emit 'connected',
    id: socket.id

  socket.on 'calibrate', ->
    model.calibrate()

  socket.on 'record', (name) ->
    storage.record name

  socket.on 'record_stop', ->
    storage.stop()

  socket.on 'disconnect', ->
    console.log 'disconnected'
    delete clients[socket.id]

respond = () ->
  for id, client of clients
    client.emit 'update', model.data()

gameLoop = (loopCode) -> setInterval loopCode, 30
gameLoop ->
  respond()


# Heroku ports or 3000
# port = process.env.PORT || 3000
# app.listen port, ->
#     console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env

