import SwiftUI
import Combine

public class Circuit: Nameable, Identifiable, Equatable, ObservableObject {
    public var devices: Array<any Device> = Array<any Device>()
    public var connections: [Connection] = [Connection]()
    
    public static var count = 0
    public var name: String
    public var id: String
    public var isExample: Bool = false
    
    public var state: BoardState = .add {
        didSet {
            canvasScene.state = state
            if state == .simulate {
                initialSolve()
                devices.forEach { $0.updateWire() }
                connections.forEach { $0.updateColor() }
            } else if oldValue == .simulate {
                resetState()
                devices.forEach { $0.resetWire() }
                connections.forEach { $0.resetColor() }
            }
        }
    }
    @Published public var selectedDevice: (any Device)?
    @Published public var selectedConnection: Connection?
    @Published public var canvasScene: CanvasScene
    
    public var arrangedDevices: [Int? : [any Device]] = [Int? : [any Device]]()
    
    public init() {
        id = "CIRCUIT" + String(Circuit.count)
        Circuit.count += 1
        name = id
        canvasScene = CanvasScene()
        canvasScene.name = id
        canvasScene.parentCircuit = self
        canvasScene.scaleMode = .resizeFill
        canvasScene.backgroundColor = UIColor.lightGray
    }
    
    deinit {
        print("Deinit circuit")
    }
    
    public func hardReset() {
        resetState()
        initialSolve()
    }
    
    public func resetState() {
        arrangedDevices = [Int? : [any Device]]()
        for device in devices {
            var device = device
            for i in 0..<device.inputCount {
                device.inputs[i] = false
            }
            for i in 0..<device.outputCount {
                device.outputs[i] = false
            }
            device.level = nil
            device.updateWire()
            device.resetVisited()
        }
        for connection in connections {
            connection.updateColor()
        }
    }
    
    public static func == (lhs: Circuit, rhs: Circuit) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func changeState(to state: BoardState) {
        self.state = state
    }
}

