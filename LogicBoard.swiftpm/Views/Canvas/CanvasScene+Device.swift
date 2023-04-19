import SpriteKit

extension CanvasScene {
    public func addDevice(_ device: some Device, at position: CGPoint) {
        let deviceNode = device.spriteNode
        
        guard let scene = scene else { return }
        deviceNode.position = CGPoint(x: cameraOffset.x + ((position.x - (frame.width / 2)) * previousCameraScale),
                                      y: cameraOffset.y + (((frame.height / 2) - position.y) * previousCameraScale))
        
        scene.addChild(deviceNode)
    }
}

