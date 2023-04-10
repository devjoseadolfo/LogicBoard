import SpriteKit

extension Device {
    func updateWire() {
        wireNodes.forEach { wireNode in
            guard let terminal = wireNode.terminal else {
                return
            }
            if wireNode.getPinType() == .input {
                guard let incomingConnection = incomingConnections[terminal],
                      let incomingConnection = incomingConnection else {
                    return
                }
                wireNode.strokeColorTransition(to: incomingConnection.state ? .canvasGreen : .canvasYellow, duration: 1/60)
            } else {
                wireNode.strokeColorTransition(to: outputs[terminal] ? .canvasGreen : .canvasYellow, duration: 1/60)
            }
        }
    }
    
    func resetWire() {
        wireNodes.forEach { wireNode in
            wireNode.strokeColorTransition(to: .darkGray)
            
        }
    }
    
    static func tagPath() -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -12, y: -8))
        path.addLine(to: CGPoint(x: 0, y: -8))
        path.addLine(to: CGPoint(x: 12, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: -12, y: 8))
        path.addLine(to: CGPoint(x: -12, y: -8))
        return path
    }

    static func twoInputGateSprite(wires: inout [SKShapeNode], pins: inout [SKSpriteNode]) -> SKSpriteNode {
        let spriteNode = SKSpriteNode()
        
        let wireNode1 = SKShapeNode()
        let wirePath1 = CGMutablePath()
        wirePath1.move(to: CGPoint(x: -128, y: 64))
        wirePath1.addLine(to: CGPoint(x: 0, y: 64))
        wireNode1.path = wirePath1
        wireNode1.strokeColor = SKColor.darkGray
        wireNode1.lineWidth = 8
        wireNode1.name = "WIRE1"
        wireNode1.userData = NSMutableDictionary()
        wireNode1.userData?.setValue(PinType.input, forKey: "type")
        wireNode1.userData?.setValue(Int(0), forKey: "terminal")
        wires.append(wireNode1)
        spriteNode.addChild(wireNode1)
        
        let wireNode2 = SKShapeNode()
        let wirePath2 = CGMutablePath()
        wirePath2.move(to: CGPoint(x: -128, y: -64))
        wirePath2.addLine(to: CGPoint(x: 0, y: -64))
        wireNode2.path = wirePath2
        wireNode2.strokeColor = SKColor.darkGray
        wireNode2.lineWidth = 8
        wireNode2.name = "WIRE2"
        wireNode2.userData = NSMutableDictionary()
        wireNode2.userData?.setValue(PinType.input, forKey: "type")
        wireNode2.userData?.setValue(Int(1), forKey: "terminal")
        wires.append(wireNode2)
        spriteNode.addChild(wireNode2)
        
        let wireNode3 = SKShapeNode()
        let wirePath3 = CGMutablePath()
        wirePath3.move(to: CGPoint(x: 0, y: 0))
        wirePath3.addLine(to: CGPoint(x: 128, y: 0))
        wireNode3.path = wirePath3
        wireNode3.strokeColor = SKColor.darkGray
        wireNode3.lineWidth = 8
        wireNode3.name = "WIRE3"
        wireNode3.userData = NSMutableDictionary()
        wireNode3.userData?.setValue(PinType.output, forKey: "type")
        wireNode3.userData?.setValue(Int(0), forKey: "terminal")
        wires.append(wireNode3)
        spriteNode.addChild(wireNode3)
        
        let pinNode1 = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode1.position = .init(x: -128, y: 64)
        pinNode1.name = "PIN1"
        pinNode1.userData = NSMutableDictionary()
        pinNode1.userData?.setValue(PinType.input, forKey: "type")
        pinNode1.userData?.setValue(Int(0), forKey: "terminal")
        pins.append(pinNode1)
        spriteNode.addChild(pinNode1)
        
        let pinShapeNode1 = SKShapeNode(rect: .init(x: -8, y: -8, width: 16, height: 16), cornerRadius: 4)
        pinShapeNode1.fillColor = SKColor.gray
        pinShapeNode1.strokeColor = SKColor.darkGray
        pinShapeNode1.lineWidth = 4
        pinShapeNode1.lineJoin = .round
        pinNode1.addChild(pinShapeNode1)
        
        let pinNode2 = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode2.position = .init(x: -128, y: -64)
        pinNode2.name = "PIN2"
        pinNode2.userData = NSMutableDictionary()
        pinNode2.userData?.setValue(PinType.input, forKey: "type")
        pinNode2.userData?.setValue(Int(1), forKey: "terminal")
        pins.append(pinNode2)
        spriteNode.addChild(pinNode2)
        
        let pinShapeNode2 = SKShapeNode(rect: .init(x: -8, y: -8, width: 16, height: 16), cornerRadius: 4)
        pinShapeNode2.fillColor = SKColor.gray
        pinShapeNode2.strokeColor = SKColor.darkGray
        pinShapeNode2.lineWidth = 4
        pinShapeNode2.lineJoin = .round
        pinNode2.addChild(pinShapeNode2)
       
        let pinNode3 = SKSpriteNode(color: .clear, size: .init(width: 36, height: 36))
        pinNode3.position = .init(x: 128, y: 0)
        pinNode3.name = "PIN3"
        pinNode3.userData = NSMutableDictionary()
        pinNode3.userData?.setValue(PinType.output, forKey: "type")
        pinNode3.userData?.setValue(false, forKey: "occupied")
        pinNode3.userData?.setValue(Int(0), forKey: "terminal")
        pins.append(pinNode3)
        spriteNode.addChild(pinNode3)
        
        let pinShapeNode3 = SKShapeNode(rect: .init(x: -8, y: -8, width: 16, height: 16), cornerRadius: 4)
        pinShapeNode3.fillColor = SKColor.gray
        pinShapeNode3.strokeColor = SKColor.darkGray
        pinShapeNode3.lineWidth = 4
        pinShapeNode3.lineJoin = .round
        pinNode3.addChild(pinShapeNode3)
        
        return spriteNode
    }
}

extension SKNode {
    var terminal: Int? {
        guard let terminal = self.userData?.value(forKey: "terminal") as? Int else { return nil }
        return terminal
    }
    
    var parentDevice: (any Device)? {
        guard let parentDevice = self.userData?.value(forKey: "parentDevice") as? any Device else { return nil }
        return parentDevice
    }
    
    var parentConnection: Connection? {
        guard let connection = self.userData?.value(forKey: "connection") as? Connection else { return nil }
        return connection
    }
    
    func getPinType() -> PinType? {
        self.userData?.value(forKey: "type") as? PinType
    }
    
    func isOccupied() -> Bool {
        guard let occupied = self.userData?.value(forKey: "occupied") as? Bool else { return false }
        return occupied
    }
    
    func occupied(_ isOcuppied: Bool) {
        self.userData?.setValue(isOcuppied, forKey: "occupied")
    }
}
