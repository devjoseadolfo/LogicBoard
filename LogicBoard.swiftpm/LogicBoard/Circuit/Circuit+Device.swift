import SpriteKit

extension Circuit {
    public func add(_ device: inout some Device, at position: CGPoint) {
        devices.append(device)
        device.assignParentCircuit(self)
        canvasScene.addDevice(device, at: position)
    }
    
    public func remove(_ device: some Device) {
        for (_, connection) in device.incomingConnections {
            if let connection = connection {
                remove(connection)
            }
        }
        
        for (_, connections) in device.outcomingConnections {
            for connection in connections {
                remove(connection)
            }
        }
        
        if let index = devices.firstIndex(where: {$0.id == device.id}) {
            device.spriteNode.removeFromParent()
            devices.remove(at: index)
        }
    }
    
    public func toggleAndSolve(_ pushButton: PushButton) {
        pushButton.toggle()
        solve(pushButton)
    }
    
    public func resetVisited() {
        for i in 0..<devices.count {
            devices[i].resetVisited()
        }
    }
}
