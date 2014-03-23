fs = require ('fs')

exports.storage =
    name: ""
    recording: false
    buf: ""

    record: (name) ->
        @name = name
        @recording = true

    stop: ->
        @recording = false
        @writeToFile(@name, @buf)
        @buf = ""

    store: (data, time) ->
        if @recording
            @buf += time + " " + data.lx + " " + data.ly + " " + data.lz + " " + data.ux + " " + data.uy + " " + data.uz + "\n"
            if @buf.length > 1024
                @writeToFile(@name, @buf)
                @buf = ""

    writeToFile: (name, data) ->
        fs.appendFileSync("recordings/" + name, data, "UTF-8",{'flags': 'a+'})  