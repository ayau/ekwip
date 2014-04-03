class Ekwip.Model
    constructor: () ->
        @u =
            x: 0
            y: 0
            z: 0
            xr: 0
            yr: 0
            zr: 0
            ax: 0
            ay: 0
            az: 0
        @l =
            x: 0
            y: 0
            z: 0
            xr: 0
            yr: 0
            zr: 0
            ax: 0
            ay: 0
            az: 0

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
        if 'lxr' of data
            @l.xr = data.lxr
        if 'lyr' of data
            @l.yr = data.lyr
        if 'lzr' of data
            @l.zr = data.lzr
        if 'uxr' of data
            @u.xr = data.uxr
        if 'uyr' of data
            @u.yr = data.uyr
        if 'uzr' of data
            @u.zr = data.uzr
        if 'lax' of data
            @l.ax = data.lax
        if 'lay' of data
            @l.ay = data.lay
        if 'laz' of data
            @l.az = data.laz
        if 'uax' of data
            @u.ax = data.uax
        if 'uay' of data
            @u.ay = data.uay
        if 'uaz' of data
            @u.az = data.uaz