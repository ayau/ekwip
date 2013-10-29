class Ekwip.Sockets
  constructor: () ->

    @socket = io.connect "#{window.location.href}"
    @socket.on 'connected', (data) =>
      console.log 'connected!'
      console.log data
      
    @socket.on 'update', (data) =>
      @model.content = data.contents

  emitHello: () =>
    @socket.emit 'key',
      payload: hello

  getSocketId: =>
    @socket.socket.sessionid