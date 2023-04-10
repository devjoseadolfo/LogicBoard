import SpriteKit

public class And: Gate, Expandable {
    public var parentCircuit: Circuit?
    
    public var deviceName: String = "AND GATE"
    public var imageName: String = "AND"
    
    public var inputs: [Bool] = [false, false]
    public var outputs: [Bool] = [false]
    
    public var incomingConnections: [Int: Connection?] = [0: nil,
                                                          1: nil]
    public var outcomingConnections: [Int: [Connection]] = [0: []]
    
    public static var count = 0
    public var id: String 
    
    public var visited: Bool = false
    public var level: Int?
    
    public var spriteNode: SKSpriteNode
    public var imageNode: SKSpriteNode
    public var wireNodes: [SKShapeNode] = [SKShapeNode]()
    public var pinNodes: [SKSpriteNode] = [SKSpriteNode]()
    
    public init() {
        Self.count += 1
        id = "AND" + String(Self.count)
        
        spriteNode = Self.twoInputGateSprite(wires: &wireNodes, pins: &pinNodes)
        
        imageNode = SKSpriteNode(imageNamed: imageName + ".png")
        imageNode.size = CGSize(width: 256, height: 256)
        imageNode.position = .init(x: 8, y: 0)
        imageNode.name = "MAIN-" + id
    
        spriteNode.addChild(imageNode)
        spriteNode.userData = NSMutableDictionary()
        spriteNode.userData?.setValue(self, forKey: "parentDevice")
    }
    
    public func run() {
        outputs[0] = inputs.allSatisfy({$0})
    }
}
