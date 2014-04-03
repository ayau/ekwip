exports.model =
    u:
        x: 0
        y: 0
        z: 0
        xr: 0
        yr: 0
        zr: 0
        ax: 0
        ay: 0
        az: 0
    l:
        x: 0
        y: 0
        z: 0
        xr: 0
        yr: 0
        zr: 0
        ax: 0
        ay: 0
        az: 0

    offset:
        u:
            x: 0
            y: 0
            z: 0
        l:
            x: 0
            y: 0
            z: 0
    time: 0
        
    update: (data, time) ->
        # console.log("roll1 " + data.roll_1 + " yaw_1 " + data.yaw_1 + " pitch_1 " + data.pitch_1)
        if time
            @time = time
        if data.pitch_1
            @l.x = data.pitch_1 + @offset.l.x
        if data.yaw_1
            @l.y = -1*data.yaw_1 + @offset.l.y
        if data.roll_1
            @l.z = data.roll_1 + @offset.l.z
        if data.pitch_2
            @u.x = data.pitch_2 + @offset.u.x
        if data.yaw_2
            @u.y = -1*data.yaw_2 + @offset.u.y
        if data.roll_2
            @u.z = data.roll_2 + @offset.u.z
        if data.pitch_r_1
            @l.xr = data.pitch_r_1
        if data.yaw_r_1
            @l.yr = data.yaw_r_1
        if data.roll_r_1
            @l.zr = data.roll_r_1
        if data.pitch_r_2
            @u.xr = data.pitch_r_2
        if data.yaw_r_2
            @u.xr = data.yaw_r_2
        if data.roll_r_2
            @u.xr = data.roll_r_2
        if data.accelx_1
            @l.ax = data.accelx_1
        if data.accely_1
            @l.ay = data.accely_1
        if data.accelz_1
            @l.az = data.accelz_1
        if data.accelx_2
            @u.ax = data.accelx_2
        if data.accely_2
            @u.ay = data.accely_2
        if data.accelz_2
            @u.az = data.accelz_2


    calibrate: ->
        @offset.u.x -= @u.x
        @offset.u.y -= @u.y
        @offset.u.z -= @u.z
        @offset.l.x -= @l.x
        @offset.l.y -= @l.y
        @offset.l.z -= @l.z

    data: ->
        return {
            "lx": @l.x
            "ly": @l.y
            "lz": @l.z
            "ux": @u.x
            "uy": @u.y
            "uz": @u.z
            "lxr": @l.xr
            "lyr": @l.yr
            "lzr": @l.zr
            "uxr": @u.xr
            "uyr": @u.yr
            "uzr": @u.zr
            "lax": @l.ax
            "lay": @l.ay
            "laz": @l.az
            "uax": @u.ax
            "uay": @u.ay
            "uaz": @u.az
            "time": @time
        }