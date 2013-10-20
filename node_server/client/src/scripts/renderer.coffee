#CONSTANTS

# global constants


class Ekwip.Renderer
    
    # GL Textures
    textures:
        leg:
            blue: new THREE.MeshLambertMaterial(color: 0x000088)


    constructor: (canvas, model, socketid) ->
        # @width = canvas.width
        # @height = canvas.width
        @ctx = canvas.element
        # @model = model
        # @socketid = socketid
        # @drawCommander = new DrawCommander()
        # @uiPieces = new UiModel @model
        @setupView(canvas)
        @createModel()
        @render()

    setupView: (root) =>
        WebGLHelper.CreateGLCanvas root, 'Canvas', false, (canvas) =>

            @scene = new THREE.Scene()
            @scene.add new THREE.AmbientLight 0x101010 #0x404040
            @scene.add new THREE.HemisphereLight(0xFFFFFF, 0x666666, 1)

            light = new THREE.DirectionalLight 0xffffff, 0.5
            light.position.set(5, -100, 200)
            @scene.add light
        
            @renderer = new THREE.WebGLRenderer 'canvas': canvas, 'precision': 'mediump'
            # renderer.autoClearColor = false
            # renderer.autoUpdateScene = false
            # renderer.setFaceCulling THREE.CullFaceNone

            @camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 20000)
            @camera.position.set(0, 0, 200)
            # @camera = new THREE.OrthographicCamera( 
            #     0, 
            #     window.innerWidth/5, 
            #     0, 
            #     -1 * window.innerHeight/5, -500, 1000)
            
            @camera.rotation.set(0.3, 0, 0)
            
            @controls = new THREE.OrbitControls @camera, @renderer.domElement
            @controls.center.set(0, 0, 0)
            @controls.addEventListener 'change', @render
            
            @scene.add @camera
            console.log @controls
            @renderer.setSize window.innerWidth, window.innerHeight

            # setInterval @render, window.INTERVAL
            window.addEventListener 'resize', @measure, false
            @measure()

            @animate()
            @render()

    render: =>
        # @myPlayerPosition = @getMyPlayerPosition() #We need this to move the viewport
        # @camera.update(@myPlayerPosition, @mouseHandler.getPosition())
        @renderer.render @scene, @camera

    animate: =>
        requestAnimationFrame @animate
        @controls.update()

    measure: =>

        windowWidth = window.innerWidth
        windowHeight = window.innerHeight

        CMAPWIDTH = windowWidth
        CMAPHEIGHT = windowHeight

        wScale = 1100 / window.innerWidth
        hScale = 765 / window.innerHeight

        if hScale > wScale
            scale = hScale
        else
            scale = wScale

        @renderer.setSize CMAPWIDTH, CMAPHEIGHT
        @camera.right = CMAPWIDTH/5 * scale
        @camera.bottom = -1 * CMAPHEIGHT/5 * scale
        @camera.updateProjectionMatrix()

        # Ekwip.ui.resize(CMAPWIDTH*scale, CMAPHEIGHT*scale)

    createModel: =>
        x = 0
        y = 0

        u =
            rotation: -70

        l =
            rotation: -30

        modelRoot = new THREE.Object3D()
        @scene.add modelRoot

        modelRoot.position.set(x, y, 0)

        # upper leg
        color = @textures.leg.blue
        upperlegMesh = new THREE.Mesh(new THREE.CylinderGeometry(5, 5, 50, 30, 30, false), color)
        upperlegMesh.position.set(0, 25, 0)
        upperleg = new THREE.Object3D()
        upperleg.add upperlegMesh
        upperleg.rotation.set(0, 0, toRadian(u.rotation))
        modelRoot.add upperleg
        modelRoot['upper'] = upperleg

        # lower leg
        lowerlegMesh = new THREE.Mesh(new THREE.CylinderGeometry(5, 5, 50, 30, 30, false), color)
        lowerlegMesh.position.set(0, -25, 0)
        lowerleg = new THREE.Object3D()
        lowerleg.add lowerlegMesh
        lowerleg.rotation.set(0, 0, toRadian(l.rotation))
        modelRoot.add lowerleg
        modelRoot['lower'] = lowerleg

        return modelRoot

    # degree to radian
    toRadian = (angle) ->
        return angle * Math.PI / 180


    # buildBackground: (map) ->
    #     SMAPWIDTH    = map.width
    #     SMAPHEIGHT   = map.height

    #     floorMesh = new THREE.Mesh( new THREE.CubeGeometry(SMAPWIDTH, SMAPHEIGHT, 1), Platoon.textures.level.floor)
    #     floorMesh.position.set(SMAPWIDTH / 2,  -1 * SMAPHEIGHT / 2, -0.5)
    #     # # floorMesh.updateMatrixWorld()
    #     @scene.add floorMesh



