import SpriteKit

class PencilPanGestureRecognizer: UIPanGestureRecognizer {
    var canvasScene: CanvasScene?
    var dragLocationStart: CGPoint?
    var originalDraggedNodeLocation: CGPoint?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let canvasScene = canvasScene,
              let scene = canvasScene.scene,
              let touch = touches.first else { return }
        let touchLocation = touch.location(in: canvasScene.view)
        let location = CGPoint(x: canvasScene.cameraOffset.x + ((touchLocation.x - (canvasScene.frame.width / 2)) * canvasScene.previousCameraScale),
                               y: canvasScene.cameraOffset.y + (((canvasScene.frame.height / 2) - touchLocation.y) * canvasScene.previousCameraScale))
        if canvasScene.state == .wire {
            canvasScene.touchedWireNode = nil
            let nodes = canvasScene.nodes(at: location)
            let pinNode = nodes
                .first { $0.name?.contains("PIN") ?? false } as? SKSpriteNode
            
            guard let pinNode = pinNode,
                  let parentNode = pinNode.parent,
                  !pinNode.isOccupied() else { return }
            canvasScene.tempStartPin = pinNode
            pinNode.colorOccupied(pinNode.getPinType() == .input)
            
            let line = SKShapeNode()
            canvasScene.tempLine = line
            line.strokeColor = SKColor.darkGray
            line.lineWidth = 8
            line.lineJoin = .round
            line.lineCap = .round
            line.zPosition = -10000
            scene.addChild(line)
            
            let pinLocation: CGPoint = .init(x: parentNode.position.x + pinNode.position.x,
                                             y:  parentNode.position.y + pinNode.position.y)
            
            canvasScene.tempLineLocations.append(pinLocation)
            canvasScene.tempLinePointCount = 1
        }
        if canvasScene.state == .add {
            let nodes = canvasScene.nodes(at: location)
            let imageNodes = nodes
                .filter {  $0.name?.contains("MAIN") ?? false }
                .map { $0 as? SKSpriteNode }
            
            for imageNode in imageNodes {
                guard let imageNode = imageNode,
                      let node = imageNode.parent as? SKSpriteNode,
                      let image = imageNode.texture?.cgImage() else { continue }
                
                var nodeTouchedLocation = scene.convert(location, to: imageNode)
                nodeTouchedLocation = CGPoint(x: (nodeTouchedLocation.x + imageNode.size.width/2) * 4,
                                              y: (nodeTouchedLocation.y + imageNode.size.height/2) * 4)
                
                guard let color = image.getPixelColor(point: nodeTouchedLocation),
                      color.alpha > 0.01 else { continue }
                
                canvasScene.draggedDeviceNode = node
                canvasScene.draggedNodePosition = node.position
                originalDraggedNodeLocation = node.position
                dragLocationStart = location
                return
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let canvasScene = canvasScene,
              let _ = canvasScene.scene,
              let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: canvasScene.view)
        let location = CGPoint(x: canvasScene.cameraOffset.x + ((touchLocation.x - (canvasScene.frame.width / 2)) * canvasScene.previousCameraScale),
                               y: canvasScene.cameraOffset.y + (((canvasScene.frame.height / 2) - touchLocation.y) * canvasScene.previousCameraScale))
        if canvasScene.state == .wire {
            guard let tempLine = canvasScene.tempLine else { return }
            print(translation(in: canvasScene.view!))
            let path = CGMutablePath()
            
            for i in 0..<canvasScene.tempLinePointCount {
                if i == 0 {
                    path.move(to: canvasScene.tempLineLocations[0])
                    continue
                }
                path.addLine(to: canvasScene.tempLineLocations[i])
            }
            
            path.addLine(to: location)
            
            tempLine.path = path
            
            if touch.perpendicularForce > 2{
                if !canvasScene.newPointCreated {
                    canvasScene.tempLineLocations.append(location)
                    canvasScene.newPointCreated = true
                    canvasScene.tempLinePointCount += 1
                }
            } else {
                if canvasScene.newPointCreated {
                    canvasScene.newPointCreated = false
                }
            }
        }
        if canvasScene.state == .add {
            guard let draggedNode = canvasScene.draggedDeviceNode,
                  let dragLocationStart = dragLocationStart,
                  let originalDraggedNodeLocation = originalDraggedNodeLocation else { return }
            let translation = CGPoint(x: location.x - dragLocationStart.x,
                                      y: location.y - dragLocationStart.y)
            draggedNode.position = CGPoint(x: originalDraggedNodeLocation.x + translation.x,
                                           y: originalDraggedNodeLocation.y + translation.y)
            
            guard let parent = draggedNode.parentDevice else { return }
            let parentLocation = draggedNode.position
            for incoming in parent.incomingConnections.values {
                guard let incoming = incoming else { continue }
                let pinLocation = parent.pinNodes[incoming.end.terminal].position
                let endLocation = CGPoint(x: parentLocation.x + pinLocation.x,
                                          y: parentLocation.y + pinLocation.y)
                incoming.updateEndPoint(to: endLocation)
            }
            for connections in parent.outcomingConnections.values {
                for connection in connections {
                    let pinLocation = parent.pinNodes[parent.inputCount + connection.start.terminal].position
                    let endLocation = CGPoint(x: parentLocation.x + pinLocation.x,
                                              y: parentLocation.y + pinLocation.y)
                    connection.updateStartPoint(to: endLocation)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let canvasScene = canvasScene,
              let _ = canvasScene.scene,
              let touch = touches.first else { return }
        if canvasScene.state == .wire {
            guard let line = canvasScene.tempLine,
                  let startNode = canvasScene.tempStartPin,
                  let circuit = canvasScene.parentCircuit else { return }
            let touchLocation = touch.location(in: canvasScene.view)
            let location = CGPoint(x: canvasScene.cameraOffset.x + ((touchLocation.x - (canvasScene.frame.width / 2)) * canvasScene.previousCameraScale),
                                   y: canvasScene.cameraOffset.y + (((canvasScene.frame.height / 2) - touchLocation.y) * canvasScene.previousCameraScale))

            let nodes = canvasScene.nodes(at: location)
            let endNode = nodes
                .first { $0.name?.contains("PIN") ?? false } as? SKSpriteNode
            
            guard let endNode = endNode,
                  let startType = startNode.getPinType(),
                  let endType = endNode.getPinType(),
                  let endParent = endNode.parent,
                  startNode != endNode,
                  startType != endType,
                  !endNode.isOccupied() else {
                startNode.colorOccupied(false)
                canvasScene.tempStartPin = nil
                line.removeFromParent()
                canvasScene.tempLine = nil
                canvasScene.tempLineLocations = []
                canvasScene.tempLinePointCount = 0
                return
            }
            
            let inputNode = startType == .input ? startNode : endNode
            let outputNode = startType == .output ? startNode : endNode
            
            guard let inputParentDevice = inputNode.parent?.parentDevice,
                  let outputParentDevice = outputNode.parent?.parentDevice,
                  let inputTerminal = inputNode.terminal,
                  let outputTerminal = outputNode.terminal else {return}
            
            
            let path = CGMutablePath()
            for i in 0..<canvasScene.tempLinePointCount {
                if i == 0 {
                    path.move(to: canvasScene.tempLineLocations[0])
                    continue
                }
                path.addLine(to: canvasScene.tempLineLocations[i])
            }
            let endLocation: CGPoint = .init(x: endParent.position.x + endNode.position.x,
                                             y:  endParent.position.y + endNode.position.y)
            path.addLine(to: endLocation)
            
            line.path = path
             
            inputNode.occupied(true)
            inputNode.colorOccupied(true)
            
            var lineLocations = canvasScene.tempLineLocations
            lineLocations.append(endLocation)
            if startType == .input {
                lineLocations.reverse()
            }
            
            let inputDevicePin: DevicePin = (inputParentDevice, inputTerminal)
            let outputDevicePin: DevicePin = (outputParentDevice, outputTerminal)
            let connection: Connection = Connection(from: outputDevicePin, to: inputDevicePin, points: lineLocations)
            circuit.addConnection(connection)
    
            canvasScene.tempStartPin = nil
            line.removeFromParent()
            canvasScene.tempLine = nil
            canvasScene.tempLineLocations = []
            canvasScene.tempLinePointCount = 0
        }
        
        if canvasScene.state == .add {
            canvasScene.draggedDeviceNode = nil
            canvasScene.draggedNodePosition = nil
        }
    }
}
    
extension UITouch {
    var perpendicularForce: CGFloat {
        if type == .pencil {
            return force / sin(altitudeAngle)
        } else {
            return force
        }
    }
}

