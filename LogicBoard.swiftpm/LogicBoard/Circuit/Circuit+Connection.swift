import SpriteKit

extension Circuit {
    public func addConnection(from start: DevicePin,
                              to end: DevicePin,
                              points: [CGPoint]) {
        guard end.terminal < end.device.inputs.count 
                && start.terminal < start.device.outputs.count else {
            return
        }
        let connection = Connection(from: start,
                                    to: end,
                                    points: points)
        connections.append(connection)
        canvasScene.addChild(connection.lineNode)
        var startDevice = start.device
        var endDevice = end.device
        
       
        startDevice.outcomingConnections[start.terminal]?.append(connection)
        endDevice.incomingConnections[end.terminal] = connection
    }
    
    public func addConnection(_ connection: Connection) {
        connections.append(connection)
        canvasScene.addChild(connection.lineNode)
        var startDevice = connection.start.device
        var endDevice = connection.end.device
        
        startDevice.outcomingConnections[connection.start.terminal]?.append(connection)
        endDevice.incomingConnections[connection.end.terminal] = connection
    }
    
    
    public func remove(_ connection: Connection) {
        guard let index = connections.firstIndex(of: connection) else {  
            return
        }
        var start = connection.start
        var end = connection.end
        
        guard let startIndex = start.device.outcomingConnections[start.terminal]?.firstIndex(of: connection)
            else { return }
        
        start.device.outcomingConnections[start.terminal]?.remove(at: startIndex)
        end.device.incomingConnections[end.terminal] = nil
        end.device.pinNodes.enumerated().forEach {
            if $0 == end.terminal {
                $1.occupied(false)
                $1.colorOccupied(false)
            }
        }
        
        canvasScene.parentCircuit?.selectedConnection = nil
        connection.lineNode.removeFromParent()
        connections.remove(at: index)
    }
    
}
