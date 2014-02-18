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

        @offset =
            u:
                x: 0
                y: 0
                z: 0
            l:
                x: 0
                y: 0
                z: 0
        
    update: (data) =>
        # console.log("roll1 " + data.roll_1 + " yaw_1 " + data.yaw_1 + " pitch_1 " + data.pitch_1)
        if data.pitch_1
            @l.x = data.pitch_1 + @offset.l.x
        if data.yaw_1
            @l.y = -1*data.yaw_1 + @offset.l.y
        if data.roll_1
            @l.z = data.roll_1 + @offset.l.z
        if data.roll_2
            @u.x = data.roll_2 + @offset.u.x
        if data.yaw_2
            @u.y = -1*data.yaw_2 + @offset.u.y
        if data.pitch_2
            @u.z = -1*data.pitch_2 + @offset.u.z

    calibrate: =>
        @offset.u.x -= @u.x
        @offset.u.y -= @u.y
        @offset.u.z -= @u.z
        @offset.l.x -= @l.x
        @offset.l.y -= @l.y
        @offset.l.z -= @l.z