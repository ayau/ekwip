window.Ekwip = {}

$ ->

    canvas = document.getElementById('GLCanvas')
    Ekwip.renderer = new Ekwip.Renderer(canvas)

    Ekwip.sockets = new Ekwip.Sockets()