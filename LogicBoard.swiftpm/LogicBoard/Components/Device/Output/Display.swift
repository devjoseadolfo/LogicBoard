import SpriteKit

public class Display: Output, Nameable {
    public var parentCircuit: Circuit?
    
    public var deviceName: String = "DISPLAY"
    public var imageName: String = "OutputFalse"
    
    public var inputs: [Bool] = [false]
    public var outputs: [Bool] = []
    public var state: Bool { inputs[0] }
    
    public var incomingConnections: [Int: Connection?] = [0: nil]
    public var outcomingConnections: [Int: [Connection]] = [Int: [Connection]]()
    
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
        id = "OUT" + String(Self.count)
        self.name = name
        
        imageNode = SKSpriteNode(imageNamed: imageName + ".png")
        imageNode.size = CGSize(width: 128, height: 128)
    
        spriteNode.addChild(imageNode)
    }
    
    public init() {
        Self.count += 1
        id = "OUT" + String(Self.count)
        self.name = id
        
        let wireNode = SKShapeNode()
        let wirePath = CGMutablePath()
        wirePath.move(to: CGPoint(x: -64, y: 0))
        wirePath.addLine(to: CGPoint(x: 0, y: 0))
        wireNode.path = wirePath
        wireNode.strokeColor = SKColor.darkGray
        wireNode.lineWidth = 8
        wireNode.name = "WIRE1"
        wireNode.userData = NSMutableDictionary()
        wireNode.userData?.setValue(PinType.input, forKey: "type")
        wireNode.userData?.setValue(Int(0), forKey: "terminal")
        wireNodes.append(wireNode)
        spriteNode.addChild(wireNode)
        
        let pinNode = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode.position =  .init(x: -64, y: 0)
        pinNode.name = "PIN1"
        pinNode.userData = NSMutableDictionary()
        pinNode.userData?.setValue(PinType.input, forKey: "type")
        pinNode.userData?.setValue(false, forKey: "occupied")
        pinNode.userData?.setValue(Int(0), forKey: "terminal")
        pinNodes.append(pinNode)
        spriteNode.addChild(pinNode)
        
        let pinShapeNode = SKShapeNode(rect: .init(origin: .init(x: -8, y: -8), size: .init(width: 16, height: 16)), cornerRadius: 4)
        pinShapeNode.fillColor = SKColor.gray
        pinShapeNode.strokeColor = SKColor.darkGray
        pinShapeNode.lineWidth = 4
        pinNode.addChild(pinShapeNode)
        
        imageNode = SKSpriteNode(imageNamed: imageName + ".png")
        imageNode.size = CGSize(width: 128, height: 128)
        imageNode.name = "MAIN-" + id
    
        spriteNode.addChild(imageNode)
        spriteNode.userData = NSMutableDictionary()
        spriteNode.userData?.setValue(self, forKey: "parentDevice")
    }
    
    public func run() {
        imageNode.texture = inputs[0] ? .onDisplayTexture : .offDisplayTexture
        //print("\(name), \(state)")
    }
}
