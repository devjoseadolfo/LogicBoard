import SpriteKit

public class PushButton: Input, Nameable {
    public var parentCircuit: Circuit?
    
    public var deviceName: String = "PUSHBUTTON"
    public var imageName: String = "InputFalse"
    
    public var inputs: [Bool] = []
    public var outputs: [Bool] = [false] {
        didSet {
            if oldValue[0] != outputs[0] {
                imageNode.texture = outputs[0] ? .onButtonTexture : .offButtonTexture
            }
        }
    }
    
    public var state: Bool { outputs[0] }
    
    public var incomingConnections: [Int: Connection?] = [Int: Connection?]()
    public var outcomingConnections: [Int: [Connection]] = [0: []]
    
    public static var count = 0
    public var id: String 
    var name: String
    
    public var visited: Bool = false
    public var level: Int?
    
    public var spriteNode: SKSpriteNode = SKSpriteNode()
    public var imageNode: SKSpriteNode
    public var wireNodes: [SKShapeNode] = [SKShapeNode]()
    public var pinNodes: [SKSpriteNode] = [SKSpriteNode]()
    
    public init(name: String) {
        Self.count += 1
        id = "IN" + String(Self.count)
        self.name = name
        
        imageNode = SKSpriteNode(imageNamed: imageName + ".png")
        imageNode.size = CGSize(width: 128, height: 128)
    
        spriteNode.addChild(imageNode)
    }
    
    public init() {
        Self.count += 1
        id = "IN" + String(Self.count)
        self.name = id
        
        let wireNode = SKShapeNode()
        let wirePath = CGMutablePath()
        wirePath.move(to: CGPoint(x: 0, y: 0))
        wirePath.addLine(to: CGPoint(x: 64, y: 0))
        wireNode.path = wirePath
        wireNode.strokeColor = SKColor.darkGray
        wireNode.userData = NSMutableDictionary()
        wireNode.userData?.setValue(PinType.output, forKey: "type")
        wireNode.userData?.setValue(Int(0), forKey: "terminal")
        wireNode.lineWidth = 8
        wireNode.name = "WIRE1"
        
        wireNodes.append(wireNode)
        spriteNode.addChild(wireNode)
        
        let pinNode = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode.position = .init(x: 64, y: 0)
        pinNode.name = "PIN1"
        pinNode.userData = NSMutableDictionary()
        pinNode.userData?.setValue(PinType.output, forKey: "type")
        pinNode.userData?.setValue(Int(0), forKey: "terminal")
        pinNodes.append(pinNode)
        spriteNode.addChild(pinNode)
        
        let pinShapeNode = SKShapeNode(rect: .init(origin: .init(x: -8, y: -8), size: .init(width: 16, height: 16)), cornerRadius: 4)
        pinShapeNode.fillColor = SKColor.gray
        pinShapeNode.name = "SHAPE"
        pinShapeNode.strokeColor = SKColor.darkGray
        pinShapeNode.lineWidth = 4
        pinShapeNode.lineJoin = .round
        pinNode.addChild(pinShapeNode)
    
        imageNode = SKSpriteNode(imageNamed: imageName + ".png")
        imageNode.size = CGSize(width: 128, height: 128)
        imageNode.name = "MAIN-" + id
    
        spriteNode.addChild(imageNode)
        spriteNode.userData = NSMutableDictionary()
        spriteNode.userData?.setValue(self, forKey: "parentDevice")
    }
    
    public func run() {
    }
    
    public func toggle() {
        outputs[0] = !outputs[0]
    }
}
