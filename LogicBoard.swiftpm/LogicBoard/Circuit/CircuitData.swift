import SpriteKit
import UniformTypeIdentifiers
import SwiftUI

struct CircuitData: Codable {
    var name: String
    var deviceDatas: [DeviceData]
    var connectionData: [ConnectionData]
    
    func makeCircuit() -> Circuit {
        var circuit = Circuit()
        circuit.changeName(to: name)
        
        for deviceData in deviceDatas {
            var device = deviceData.makeDevice()
            circuit.add(&device, at: .zero)
            device.spriteNode.position = deviceData.location
        }
        
        for connectionData in connectionData {
            guard let startPoint = connectionData.points.first,
                  let endPoint = connectionData.points.last else {
                continue
            }
            
            let startNodes = circuit.canvasScene.nodes(at: startPoint)
            let endNodes = circuit.canvasScene.nodes(at: endPoint)
            
            guard let startPinNode = startNodes.first(where: { $0.name?.contains("PIN") ?? false }),
                  let endPinNode = endNodes.first(where: { $0.name?.contains("PIN") ?? false }) else {
                continue
            }
                  
            guard let startDevice = startPinNode.parent?.parentDevice,
                  let endDevice = endPinNode.parent?.parentDevice else {
                continue
            }
            
            guard let startTerminal = startPinNode.terminal,
                  let endTerminal = endPinNode.terminal else {
                continue
            }
            
            let startDevicePin = (startDevice, startTerminal)
            let endDevicePin = (endDevice, endTerminal)
            
            endPinNode.occupied(true)
            endPinNode.colorOccupied(true)
            
            let connection = Connection(from: startDevicePin, to: endDevicePin, points: connectionData.points)
            circuit.addConnection(connection)
        }
        
        return circuit
    }
}

struct DeviceData: Codable {
    let deviceName : DeviceName
    let location: CGPoint
    
    func makeDevice() -> any Device {
        let device = deviceName.deviceNameToDevice()
        return device
    }
}

struct ConnectionData: Codable {
    let points: [CGPoint]
}


extension Circuit {
    func makeCircuitData() -> CircuitData {
        var deviceDatas = [DeviceData]()
        var connectionDatas = [ConnectionData]()
        for device in self.devices {
            deviceDatas.append(DeviceData(deviceName: DeviceName.deviceStringToDeviceName(string: device.deviceName), location: device.spriteNode.position))
        }
        for connection in self.connections {
            connectionDatas.append(ConnectionData(points: connection.points))
        }
        
        return CircuitData(name: self.name, deviceDatas: deviceDatas, connectionData: connectionDatas)
    }
}

extension UTType {
    static let circ = UTType(exportedAs: "com.joseadolfo.circ", conformingTo: .json)
}
