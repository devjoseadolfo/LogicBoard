import SpriteKit

public class Buffer: Gate {
    public var parentCircuit: Circuit?
    
    public var deviceName: String = "BUFFER"
    public var imageName: String = "BUFFER"
    
    public var inputs: [Bool] = [false]
    public var outputs: [Bool] = [true]
    
    public var incomingConnections: [Int: Connection?] = [0: nil]
    public var outcomingConnections: [Int: [Connection]] = [0: []]
    
    public static var count = 0
    public var id: String
    
    public var visited: Bool = false
    public var level: Int?
    
    public var spriteNode: SKSpriteNode = SKSpriteNode()
    public var imageNode: SKSpriteNode
    public var wireNodes: [SKShapeNode] = [SKShapeNode]()
    public var pinNodes: [SKSpriteNode] = [SKSpriteNode]()
    
    public init() {
        Self.count += 1
        id = "BUFFER" + String(Self.count)
        
        let wireNode1 = SKShapeNode()
        let wirePath1 = CGMutablePath()
        wirePath1.move(to: CGPoint(x: -64, y: 0))
        wirePath1.addLine(to: CGPoint(x: 0, y: 0))
        wireNode1.path = wirePath1
        wireNode1.strokeColor = SKColor.darkGray
        wireNode1.lineWidth = 8
        wireNode1.name = "WIRE1"
        wireNode1.userData = NSMutableDictionary()
        wireNode1.userData?.setValue(PinType.input, forKey: "type")
        wireNode1.userData?.setValue(Int(0), forKey: "terminal")
        
        wireNodes.append(wireNode1)
        spriteNode.addChild(wireNode1)
        
        let wireNode2 = SKShapeNode()
        let wirePath2 = CGMutablePath()
        wirePath2.move(to: CGPoint(x: 0, y: 0))
        wirePath2.addLine(to: CGPoint(x: 64, y: 0))
        wireNode2.path = wirePath2
        wireNode2.strokeColor = SKColor.darkGray
        wireNode2.lineWidth = 8
        wireNode2.name = "WIRE2"
        wireNode2.userData = NSMutableDictionary()
        wireNode2.userData?.setValue(PinType.output, forKey: "type")
        wireNode2.userData?.setValue(Int(0), forKey: "terminal")
        
        wireNodes.append(wireNode2)
        spriteNode.addChild(wireNode2)
        
        let pinNode1 = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode1.position = .init(x: -64, y: 0)
        pinNode1.name = "PIN1"
        pinNode1.userData = NSMutableDictionary()
        pinNode1.userData?.setValue(PinType.input, forKey: "type")
        pinNode1.userData?.setValue(Int(0), forKey: "terminal")
        pinNodes.append(pinNode1)
        spriteNode.addChild(pinNode1)
        
        let pinShapeNode1 = SKShapeNode(rect: .init(origin: .init(x: -8, y: -8), size: .init(width: 16, height: 16)), cornerRadius: 4)
        pinShapeNode1.fillColor = SKColor.gray
        pinShapeNode1.strokeColor = SKColor.darkGray
        pinShapeNode1.lineWidth = 4
        pinNode1.addChild(pinShapeNode1)
        
        let pinNode2 = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode2.position = .init(x: 64, y: 0)
        pinNode2.name = "PIN2"
        pinNode2.userData = NSMutableDictionary()
        pinNode2.userData?.setValue(PinType.output, forKey: "type")
        pinNode2.userData?.setValue(false, forKey: "occupied")
        pinNode2.userData?.setValue(Int(0), forKey: "terminal")
        pinNodes.append(pinNode2)
        spriteNode.addChild(pinNode2)
        
        let pinShapeNode2 = SKShapeNode(rect: .init(origin: .init(x: -8, y: -8), size: .init(width: 16, height: 16)), cornerRadius: 4)
        pinShapeNode2.fillColor = SKColor.gray
        pinShapeNode2.strokeColor = SKColor.darkGray
        pinShapeNode2.lineWidth = 4
        pinShapeNode2.lineJoin = .round
        pinNode2.addChild(pinShapeNode2)
        
        imageNode = SKSpriteNode(imageNamed: imageName + ".png")
        imageNode.size = CGSize(width: 128, height: 128)
        imageNode.position = .init(x: 8, y: 0)
        imageNode.name = "MAIN-" + id
    
        spriteNode.addChild(imageNode)
        spriteNode.userData = NSMutableDictionary()
        spriteNode.userData?.setValue(self, forKey: "parentDevice")
    }
    
    public func run() {
        outputs[0] = inputs[0]
    }
}
