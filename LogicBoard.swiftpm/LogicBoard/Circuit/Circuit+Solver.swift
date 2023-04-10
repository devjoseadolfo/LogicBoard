extension Circuit {
    public func initialSolve() {
        assignLevel()
        perLevelSolve()
    }
    
    public func assignLevel() {
        devices
            .filter {$0 is PushButton }
            .forEach {
                
                var button = $0
                recursiveAssignLevel(start: &button)
            }
        devices
            .forEach { device in
                guard let _ = arrangedDevices[device.level] else {
                    arrangedDevices[device.level] = [device]
                    return
                }
                arrangedDevices[device.level]?.append(device)
            }
        resetVisited()
    }
    
    public func recursiveAssignLevel(start device: inout any Device, level: Int = 0) {
        if device.visited {
            return
        }
        if let currentLevel = device.level, level >= currentLevel {
            return
        }
        device.level = level
        device.visited = true
    
        for (_, connections) in device.outcomingConnections {
            for connection in connections {
                recursiveAssignLevel(start: &connection.end.device, level: level + 1)
            }
        }
    }
    
    func perLevelSolve() {
        let keys = arrangedDevices.keys.sorted {
            guard let first = $0, let second = $1 else {
                return false
            }
            return first < second
        }
        
        var queue: [(DevicePin, Bool)] = []
        
        for key in keys {
            guard let key = key else {
                guard let devices = arrangedDevices[key] else { continue }
                for device in devices {
                    solve(device)
                }
                continue
            }
            
            guard let devices = arrangedDevices[key] else { continue }
            for device in devices {
                device.run()
                device.updateWire()
                for (_, connections) in device.outcomingConnections {
                    for connection in connections {
                        connection.updateColor()
                        let endDevice = connection.end.device
                        let endTerminal = connection.end.terminal
                        endDevice.wireNodes[endTerminal].strokeColorTransition(to: connection.state ? .canvasGreen : .canvasYellow)
                        if endDevice is Display {
                            var endDevice = endDevice
                            endDevice.inputs[0] = connection.state
                        } else if device.id != endDevice.id {
                            queue.append((connection.end, connection.state))
                        }
                    }
                }
            }
        }
        
        for item in queue {
            var item = item
            item.0.device.inputs[item.0.terminal] = item.1
        }
        resetVisited()
    }
    
    func solve(_ startDevice: any Device) {
        recursiveSolve(startDevice)
        resetVisited()
    }
    
    func recursiveSolve(_ device: any Device,
                        path: [any Device] = []) {
        device.run()
        device.updateWire()
        
        for (_, connections) in device.outcomingConnections {
            for connection in connections {
                connection.updateColor()
                connection.end.device.updateWire()
                if !path.contains(where: {$0.id == device.id}) {
                    connection.end.device.inputs[connection.end.terminal] = connection.start.device.outputs[connection.start.terminal]
                    recursiveSolve(connection.end.device, path: path + [device])
                }
            }
        }
    }
}
