#CONSTANTS
window.INTERVAL = 20  #rate of redraw

# global constants


class Ekwip.Renderer
    
    # GL Textures
    textures:
        leg:
            blue: new THREE.MeshLambertMaterial(color: 0x000088)
        rainbow: new THREE.MeshNormalMaterial()


    constructor: (canvas, model, socketid) ->
        # TODO use canvas width and height
        # @width = canvas.width
        # @height = canvas.width
        @ctx = canvas.element
        @model = model
        # @socketid = socketid
        # @drawCommander = new DrawCommander()
        # @uiPieces = new UiModel @model
        @setupView(canvas)
        @modelRoot = @createModel()
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
            
            
            @controls = new THREE.OrbitControls @camera, @renderer.domElement
            @controls.center.set(0, 0, 0)
            @controls.addEventListener 'change', @render
            
            @scene.add @camera
            
            @renderer.setSize window.innerWidth, window.innerHeight

            setInterval @render, window.INTERVAL
            # setInterval @render, window.INTERVAL
            window.addEventListener 'resize', @measure, false
            @measure()

            @animate()

    render: =>
        @updateModel()
        # @myPlayerPosition = @getMyPlayerPosition() #We need this to move the viewport
        @renderer.render @scene, @camera

    animate: =>
        requestAnimationFrame @animate
        @controls.update()

    measure: =>

        windowWidth = window.innerWidth
        windowHeight = window.innerHeight

        @renderer.setSize windowWidth, windowHeight
        @camera.aspect = windowWidth/windowHeight
        @camera.updateProjectionMatrix()
        @render()

        # Ekwip.ui.resize(CMAPWIDTH*scale, CMAPHEIGHT*scale)

    createModel: =>
        x = 0
        y = 0

        u =
            rx: 0
            ry: 0
            rz: 0

        l =
            rx: 0
            ry: 0
            rz: 0

        modelRoot = new THREE.Object3D()
        @scene.add modelRoot

        modelRoot.position.set(x, y, 0)

        # upper leg
        color = @textures.leg.blue
        upperlegMesh = new THREE.Mesh(new THREE.CylinderGeometry(10, 5, 50, 30, 30, false), color)
        upperlegMesh.position.set(0, 26, 0)
        upperleg = new THREE.Object3D()
        upperleg.add upperlegMesh
        upperleg.rotation.set(toRadian(u.rx), toRadian(u.ry), toRadian(u.rz))
        modelRoot.add upperleg
        modelRoot['upper'] = upperleg

        # lower leg
        lowerlegMesh = new THREE.Mesh(new THREE.CylinderGeometry(5, 7, 16, 30, 30, false), color)
        lowerlegMesh.position.set(0.5, -9, 0)
        lowerlegMesh.rotation.set(0, 0, 0.08)
        lowerlegMesh2 = new THREE.Mesh(new THREE.CylinderGeometry(7, 4, 34, 30, 30, false), color)
        lowerlegMesh2.position.set(0, -33, 0)
        lowerlegMesh2.rotation.set(0, 0, -0.07)
        lowerleg = new THREE.Object3D()
        lowerleg.add lowerlegMesh
        lowerleg.add lowerlegMesh2
        lowerleg.rotation.set(toRadian(l.rx), toRadian(l.ry), toRadian(l.rz))
        modelRoot.add lowerleg
        modelRoot['lower'] = lowerleg

        # knee
        color = @textures.rainbow
        kneeMesh = new THREE.Mesh(new THREE.SphereGeometry(5, 30, 30), color);
        modelRoot.add kneeMesh

        return modelRoot

    updateModel: =>
        # targetRotation = @modelRoot.upper.rotation.clone()
        # targetRotation.set(@model.u.x, @model.u.y, @model.u.z)
        # @modelRoot.upper.rotation.lerp(targetRotation, 0.8)
        @modelRoot.upper.rotation.set(toRadian(@model.u.x), toRadian(@model.u.y), toRadian(@model.u.z))

        # targetRotation = @modelRoot.lower.rotation.clone()
        # targetRotation.set(@model.l.x, @model.l.y, @model.l.z)
        # @modelRoot.lower.rotation.lerp(targetRotation, 0.8)
        @modelRoot.lower.rotation.set(toRadian(@model.l.x), toRadian(@model.l.y), toRadian(@model.l.z))

    # degree to radian
    toRadian = (angle) ->
        return angle * Math.PI / 180

