import SpriteKit

public class CanvasScene: SKScene, ObservableObject {
    var parentCircuit: Circuit?
    
    var inited = false
    
    var previousCameraPoint = CGPoint.zero
    var originalCameraPoint = CGPoint.zero
    var cameraPoint = CGPoint.zero
    var cameraOffset = CGPoint.zero
    
    var state: ViewState = .add {
        didSet {
            touchedDeviceNode = nil
            touchedWireNode = nil
            if state == .simulate {
                parentCircuit?.devices.forEach {
                    $0.pinNodes.forEach {
                        $0.opacityTransition(0)
                    }
                }
            } else if oldValue == .simulate {
                parentCircuit?.devices.forEach {
                    $0.pinNodes.forEach {
                        $0.removeTint()
                        $0.opacityTransition(1)
                    }
                }
            }
        }
    }
    
    var touchedDeviceNode: SKSpriteNode? = nil {
        didSet {
            if touchedDeviceNode == nil {
                parentCircuit?.selectedDevice = nil
                guard oldValue != draggedDeviceNode else { return }
                oldValue?.removeTint()
            } else if oldValue != touchedDeviceNode {
                guard let parentDevice = touchedDeviceNode?.parentDevice else { return }
                parentCircuit?.selectedDevice = parentDevice
                oldValue?.removeTint()
                touchedDeviceNode?.blueTint()
            }
        }
    }

    var draggedDeviceNode: SKSpriteNode? = nil {
        didSet {
            touchedDeviceNode = nil
            if draggedDeviceNode == nil {
                oldValue?.removeTint()
            } else {
                oldValue?.removeTint()
                draggedDeviceNode?.blueTint()
            }
        }
    }
    var draggedNodePosition: CGPoint? = nil
    
    
    var touchedWireNode: SKShapeNode? = nil {
        didSet {
            if touchedWireNode == nil {
                parentCircuit?.selectedConnection = nil
                guard oldValue != touchedWireNode, state != .simulate else { return }
                oldValue?.strokeColorTransition(to: .darkGray)
            } else if oldValue != touchedWireNode {
                guard let parentConnection = touchedWireNode?.parentConnection else {
                    return
                }
                parentCircuit?.selectedConnection = parentConnection
                oldValue?.strokeColorTransition(to: .darkGray)
                touchedWireNode?.strokeColorTransition(to: .canvasBlue)
            }
        }
    }
    
    var tempLine: SKShapeNode?
    var tempLineLocations: [CGPoint] = [CGPoint]()
    var tempLinePointCount: Int = 0
    var tempStartPin: SKSpriteNode?
    var newPointCreated: Bool = false
    
    public override func didMove(to view: SKView) {
        guard let scene = scene else { return }
        
        let oneFingerTapRecognizer = UITapGestureRecognizer()
        oneFingerTapRecognizer.addTarget(self, action: #selector(oneFingerTap))
        
        view.addGestureRecognizer(oneFingerTapRecognizer)
        
        let oneFingerPanRecognizer = UIPanGestureRecognizer()
        oneFingerPanRecognizer.addTarget(self, action: #selector(oneFingerPan))
        oneFingerPanRecognizer.allowedTouchTypes = [0,3]
        oneFingerPanRecognizer.minimumNumberOfTouches = 1
        oneFingerPanRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(oneFingerPanRecognizer)
        
        let pencilPanRecognizer = CanvasPanGestureRecognizer()
        pencilPanRecognizer.canvasScene = self
        pencilPanRecognizer.canvasView = view
        pencilPanRecognizer.allowedTouchTypes = [2]
        pencilPanRecognizer.minimumNumberOfTouches = 1
        pencilPanRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(pencilPanRecognizer)
        
        let twoFingerPanRecognizer = UIPanGestureRecognizer()
        twoFingerPanRecognizer.addTarget(self, action: #selector(twoFingerPan))
        twoFingerPanRecognizer.allowedScrollTypesMask = .continuous
        twoFingerPanRecognizer.minimumNumberOfTouches = 2
        twoFingerPanRecognizer.maximumNumberOfTouches = 2
        
        view.addGestureRecognizer(twoFingerPanRecognizer)
        
        let camera = SKCameraNode()
        
        if !inited {
            camera.position = CGPoint(x: 0, y: 0)
            cameraPoint = camera.position
            originalCameraPoint = camera.position
            inited = true
        } else {
            camera.position = cameraPoint
        }
        
        scene.camera = camera
        self.addChild(camera)
    }
    
    
}
