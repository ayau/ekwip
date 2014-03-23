window.Ekwip = {}

$ ->

    recording = false
    recording_name = ""

    model = new Ekwip.Model()

    Ekwip.sockets = new Ekwip.Sockets(model)

    canvas = document.getElementById('GLCanvas')
    Ekwip.renderer = new Ekwip.Renderer(canvas, model)

    $(document).ready ->
        $('#btn-calibrate').click () ->
            console.log 'calibrating..'
            Ekwip.sockets.emitCalibrate()

        $('#btn-record').click () ->
            if !recording
                console.log 'recording..'
                recording_name = $('#input-record').val() + '.txt'
                Ekwip.sockets.emitRecording(recording_name)
                $('#btn-record').html('Finish')
                $('#record-hint').text('Recording -> ' + recording_name)
                $('#input-record').val('')
                $('#input-record').hide()
                $('#record-hint').show()
            else
                console.log 'stopped recording'
                Ekwip.sockets.stopRecording()
                $('#btn-record').html('Record')
                $('#input-record').show()
                $('#record-hint').hide()
                $('#recordings').append('<li><a href="download?n=' + recording_name + '">' + recording_name + '</a></li>')
            recording = !recording
