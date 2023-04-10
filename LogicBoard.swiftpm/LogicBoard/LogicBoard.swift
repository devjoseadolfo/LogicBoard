import Foundation
public struct LogicBoard {
    public var mainCircuit: Circuit
    public var circuits: [Circuit] = [Circuit]()
    public var selectedCircuit: Circuit
    public var state: ViewState = .file {
        didSet {
            circuits.forEach { circuit in
                circuit.state = state
            }
        }
    }
    
    public init() {
        mainCircuit = Circuit.fullAdder()
        mainCircuit.isExample = true
        circuits.append(mainCircuit)
        
        let dLatch = Circuit.dLatch()
        dLatch.isExample = true
        circuits.append(dLatch)
        selectedCircuit = mainCircuit
    }
    
    public mutating func addCircuit() {
        circuits.append(Circuit())
    }
    
    public mutating func addCircuit(_ circuit: Circuit) {
        circuits.append(circuit)
    }
    
    public mutating func removeCircuit(_ circuit: Circuit) {
        guard let index = circuits.firstIndex(of: circuit) else {
            return
        }
        circuits.remove(at: index)
    }
}

extension LogicBoard {
    subscript(index: Int) -> Circuit {
        get {
            self.circuits[index]
        } 
        set {
            self.circuits[index] = newValue
        }
    }
}
