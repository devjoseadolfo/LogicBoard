import SpriteKit
import UIKit

public class CanvasScene: SKScene, ObservableObject, UIGestureRecognizerDelegate {
    var parentCircuit: Circuit?
    
    var inited = false
    
    var previousCameraPoint = CGPoint.zero
    var originalCameraPoint = CGPoint.zero
    var cameraPoint = CGPoint.zero
    var cameraOffset = CGPoint.zero
    
    var state: BoardState = .add {
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

    var previousCameraScale: CGFloat = 1.5
    
    let oneFingerTapRecognizer = UITapGestureRecognizer()
    let oneFingerPanRecognizer = UIPanGestureRecognizer()
    let pencilPanRecognizer = PencilPanGestureRecognizer()
    let twoFingerPanRecognizer = UIPanGestureRecognizer()
    let twoFingerPinchRecognizer = UIPinchGestureRecognizer()
    
    public override func didMove(to view: SKView) {
        guard let scene = scene else { return }
        
        oneFingerTapRecognizer.addTarget(self, action: #selector(tap))
        oneFingerTapRecognizer.delegate = self
        oneFingerTapRecognizer.allowedTouchTypes = [0,2,3]
        oneFingerTapRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(oneFingerTapRecognizer)
        
        oneFingerPanRecognizer.addTarget(self, action: #selector(oneFingerPan))
        oneFingerPanRecognizer.delegate = self
        oneFingerPanRecognizer.allowedTouchTypes = [0,3]
        oneFingerPanRecognizer.minimumNumberOfTouches = 1
        oneFingerPanRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(oneFingerPanRecognizer)
        
        pencilPanRecognizer.canvasScene = self
        pencilPanRecognizer.delegate = self
        pencilPanRecognizer.allowedTouchTypes = [2]
        pencilPanRecognizer.minimumNumberOfTouches = 1
        pencilPanRecognizer.maximumNumberOfTouches = 1
        pencilPanRecognizer.delaysTouchesBegan = true
        view.addGestureRecognizer(pencilPanRecognizer)
             
        twoFingerPanRecognizer.addTarget(self, action: #selector(twoFingerPan))
        twoFingerPanRecognizer.allowedScrollTypesMask = .continuous
        twoFingerPanRecognizer.minimumNumberOfTouches = 2
        twoFingerPanRecognizer.maximumNumberOfTouches = 2
        twoFingerPanRecognizer.delegate = self
        view.addGestureRecognizer(twoFingerPanRecognizer)
        
        twoFingerPinchRecognizer.addTarget(self, action: #selector(pinch))
        twoFingerPinchRecognizer.delegate = self
        view.addGestureRecognizer(twoFingerPinchRecognizer)
        
        let camera = SKCameraNode()
        
        if !inited {
            camera.position = CGPoint(x: 0, y: 0)
            cameraPoint = camera.position
            originalCameraPoint = camera.position
            camera.setScale(1.5)
            inited = true
        } else {
            camera.position = cameraPoint
        }
        
        scene.camera = camera
        self.addChild(camera)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == twoFingerPanRecognizer && otherGestureRecognizer == twoFingerPinchRecognizer)
            || (gestureRecognizer == twoFingerPinchRecognizer && otherGestureRecognizer == twoFingerPanRecognizer) {
            return true
        } else {
            return false
        }
    }
}
