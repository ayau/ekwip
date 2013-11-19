window.Ekwip = {}

$ ->

    model = new Ekwip.Model()

    Ekwip.sockets = new Ekwip.Sockets(model)

    canvas = document.getElementById('GLCanvas')
    Ekwip.renderer = new Ekwip.Renderer(canvas, model)

    $(document).ready ->
        $('#btn-calibrate').click () ->
            console.log 'calibrating..'
            model.calibrate()
