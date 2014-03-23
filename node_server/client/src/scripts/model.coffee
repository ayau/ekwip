class Ekwip.Model
    constructor: () ->
        @u =
            x: 0
            y: 0
            z: 0
        @l =
            x: 0
            y: 0
            z: 0
        
    update: (data) =>
        # console.log("x " + data.lx + " y " + data.ly + " z " + data.lz)
        if 'lx' of data
            @l.x = data.lx
        if 'ly' of data
            @l.y = data.ly
        if 'lz' of data
            @l.z = data.lz
        if 'ux' of data
            @u.x = data.ux
        if 'uy' of data
            @u.y = data.uy
        if 'uz' of data
            @u.z = data.uz