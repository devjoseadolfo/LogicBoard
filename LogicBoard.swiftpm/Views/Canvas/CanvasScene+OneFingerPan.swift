import SpriteKit

extension CanvasScene {
    @objc func oneFingerPan(recognizer: UIPanGestureRecognizer) {
        guard let scene = scene else { return }
        let touchLocation = recognizer.location(in: self.view)
        let location = CGPoint(x: cameraOffset.x + ((touchLocation.x - (frame.width / 2)) * previousCameraScale),
                               y: cameraOffset.y + (((frame.height / 2) - touchLocation.y) * previousCameraScale))
        if state == .wire {
            if recognizer.state == .began {
                let nodes = self.nodes(at: location)
                let pinNode = nodes
                    .first { $0.name?.contains("PIN") ?? false } as? SKSpriteNode
                    
                guard let pinNode = pinNode,
                      let parentNode = pinNode.parent,
                      !pinNode.isOccupied() else { return }
                tempStartPin = pinNode
                pinNode.colorOccupied(pinNode.getPinType() == .input)
                
                let line = SKShapeNode()
                tempLine = line
                line.strokeColor = SKColor.darkGray
                line.lineWidth = 8
                line.lineJoin = .round
                line.lineCap = .round
                line.zPosition = -10000
                scene.addChild(line)
                
                let pinLocation: CGPoint = .init(x: parentNode.position.x + pinNode.position.x,
                                                 y:  parentNode.position.y + pinNode.position.y)
                
                tempLineLocations.append(pinLocation)
                tempLinePointCount = 1
            }
            if recognizer.state == .changed {
                guard let tempLine = tempLine else { return }
                let path = CGMutablePath()
                
                for i in 0..<tempLinePointCount {
                    if i == 0 {
                        path.move(to: tempLineLocations[0])
                        continue
                    }
                    path.addLine(to: tempLineLocations[i])
                }
                
                path.addLine(to: location)
        
                tempLine.path = path
                
                let velocity: CGPoint = recognizer.velocity(in: self.view)
                let velocityMagnitude: CGFloat = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
                let lastLocation = tempLineLocations.last
                let distance = sqrt(pow(location.x - lastLocation!.x, 2) + pow(location.y - lastLocation!.y, 2))
                if velocityMagnitude < 10, distance > 32 {
                    if !newPointCreated {
                        tempLineLocations.append(location)
                        newPointCreated = true
                        tempLinePointCount += 1
                    }
                } else {
                    if newPointCreated {
                        newPointCreated = false
                    }
                }
                
            }
            if recognizer.state == .ended {
                guard let line = tempLine,
                      let startNode = tempStartPin,
                      let circuit = parentCircuit else { return }
                
                let nodes = self.nodes(at: location)
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
                    tempStartPin = nil
                    line.removeFromParent()
                    tempLine = nil
                    tempLineLocations = []
                    tempLinePointCount = 0
                    return
                }
                
                let inputNode = startType == .input ? startNode : endNode
                let outputNode = startType == .output ? startNode : endNode
                
                guard let inputParentDevice = inputNode.parent?.parentDevice,
                      let outputParentDevice = outputNode.parent?.parentDevice,
                      let inputTerminal = inputNode.terminal,
                      let outputTerminal = outputNode.terminal else {return}
                
                
                let path = CGMutablePath()
                for i in 0..<tempLinePointCount {
                    if i == 0 {
                        path.move(to: tempLineLocations[0])
                        continue
                    }
                    path.addLine(to: tempLineLocations[i])
                }
                let endLocation: CGPoint = .init(x: endParent.position.x + endNode.position.x,
                                                 y:  endParent.position.y + endNode.position.y)
                path.addLine(to: endLocation)
                
                line.path = path
                 
                inputNode.occupied(true)
                inputNode.colorOccupied(true)
                
                var lineLocations = tempLineLocations
                lineLocations.append(endLocation)
                if startType == .input {
                    lineLocations.reverse()
                }
                
                let inputDevicePin: DevicePin = (inputParentDevice, inputTerminal)
                let outputDevicePin: DevicePin = (outputParentDevice, outputTerminal)
                let connection: Connection = Connection(from: outputDevicePin, to: inputDevicePin, points: lineLocations)
                circuit.addConnection(connection)
        
                tempStartPin = nil
                line.removeFromParent()
                tempLine = nil
                tempLineLocations = []
                tempLinePointCount = 0
            }

        }
        
        if state == .add {
            if recognizer.state == .began {
                let nodes = self.nodes(at: location)
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
                          color.cgColor.alpha > 0.01 else { continue }
                    
                    draggedDeviceNode = node
                    draggedNodePosition = node.position
                    return
                }
            }
            if recognizer.state == .changed {
                guard let draggedNode = draggedDeviceNode,
                      let draggedNodePosition = draggedNodePosition else { return }
                let translation = recognizer.translation(in: self.view)
                let newPosition = CGPoint(
                  x: draggedNodePosition.x + translation.x,
                  y: draggedNodePosition.y + translation.y * -1
                )
                draggedNode.position = newPosition
                
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
            if recognizer.state == .ended {
                draggedDeviceNode = nil
                draggedNodePosition = nil
            }
        }
    }
}
