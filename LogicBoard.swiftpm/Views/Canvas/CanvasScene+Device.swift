import SpriteKit

extension CanvasScene {
    public func addDevice(_ device: some Device, at position: CGPoint) {
        let deviceNode = device.spriteNode
        
        guard let scene = scene else { return }
        deviceNode.position = CGPoint(x: (position.x + cameraOffset.x - (frame.width / 2)),
                                      y: ((frame.height / 2) - position.y + cameraOffset.y))
        
        scene.addChild(deviceNode)
    }
}

