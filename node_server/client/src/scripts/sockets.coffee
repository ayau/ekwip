class Ekwip.Sockets
  constructor: (model) ->
    @model = model

    @socket = io.connect "#{window.location.href}"
    @socket.on 'connected', (data) =>
      console.log 'connected!'
      console.log data
      
    @socket.on 'update', (data) =>
      @model.update(data)

  # emitCalibrate: () =>
  #   @socket.emit 'calibrate'

  getSocketId: =>
    @socket.socket.sessionid