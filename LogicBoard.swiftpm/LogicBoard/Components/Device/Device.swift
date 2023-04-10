import SpriteKit

public protocol Device: Identifiable, Component {
    var parentCircuit: Circuit? { get set }
    
    var inputs: [Bool] { get set }
    var outputs: [Bool] { get set }
    
    var deviceName: String { get }
    var imageName: String { get }
   
    static var count: Int { get set }
    var id: String { get set }
    
    var incomingConnections: [Int: Connection?] { get set }
    var outcomingConnections: [Int: [Connection]] { get set }
    
    var visited: Bool { get set }
    var level: Int? { get set }
    
    var spriteNode: SKSpriteNode { get set }
    var imageNode: SKSpriteNode { get set }
    var wireNodes: [SKShapeNode] { get set }
    var pinNodes: [SKSpriteNode] { get set }
    
    func run()
}

extension Device {
    var inputCount: Int { inputs.count }
    var outputCount: Int { outputs.count }
    
    static func ==(lhs: any Device, rhs: any Device) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func assignParentCircuit(_ parent: Circuit) {
        self.parentCircuit = parent
    }
    
    mutating func resetVisited() {
        visited = false
    }
}

protocol Input: Device { }

protocol Output: Device { }

public protocol Gate: Device { }

public protocol Expandable: Gate { }
