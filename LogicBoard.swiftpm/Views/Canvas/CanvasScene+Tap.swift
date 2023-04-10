import SpriteKit

extension CanvasScene {
    @objc func oneFingerTap(recognizer: UITapGestureRecognizer) {
        guard let scene = scene else { return }
        let touchLocation = recognizer.location(in: self.view)
        let location = CGPoint(x: cameraOffset.x + ((touchLocation.x - (frame.width / 2)) * previousCameraScale),
                               y: cameraOffset.y + (((frame.height / 2) - touchLocation.y) * previousCameraScale))
        if state == .add {
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
                      color.alpha > 0.01 else { continue }
                
                touchedDeviceNode = touchedDeviceNode == node ? nil : node
                return
            }
            touchedDeviceNode = nil
        }
        if state == .wire {
            let nodes = self.nodes(at: location)
            let wireNodes = nodes
                .filter {  $0.name?.contains("CONNECTION") ?? false }
                .map { $0 as? SKShapeNode }
            for wireNode in wireNodes {
                guard let wireNode = wireNode,
                      let image = view?.texture(from: wireNode)?.cgImage() else { continue }
                let wireFrame = wireNode.frame
                let wireTouchedLocation = CGPoint(x: location.x - wireFrame.minX,
                                                  y: location.y - wireFrame.minY)
                let pixelPosition = CGPoint(x: wireTouchedLocation.x * CGFloat(image.width) / wireFrame.width,
                                            y: CGFloat(image.height) - (wireTouchedLocation.y * CGFloat(image.height) / wireFrame.height))
            
               
                guard let color = image.getPixelColor(point: pixelPosition),
                      color.alpha > 0.05 else { continue }
                
                touchedWireNode = touchedWireNode == wireNode ? nil : wireNode
                
                return
            }
            touchedWireNode = nil
        }
        if state == .simulate {
            let nodes = self.nodes(at: location)
            
            let buttonNode = nodes
                .filter {  $0.parentDevice is PushButton }
                .first
            
            guard let button = buttonNode?.parentDevice as? PushButton,
                  let circuit = parentCircuit else { return }
            circuit.toggleAndSolve(button)
        }
    }
}
