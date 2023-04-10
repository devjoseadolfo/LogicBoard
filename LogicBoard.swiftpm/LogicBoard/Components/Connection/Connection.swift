import SpriteKit

public class Connection: Identifiable, Equatable {
    var start: DevicePin
    var end: DevicePin
    
    public static var count = 0
    public var id: String
    
    public var points: [CGPoint] = []
    public var lineNode: SKShapeNode = SKShapeNode()
    
    public var state: Bool { start.device.outputs[start.terminal] }
    
    
    public init(from start: DevicePin, 
                to end: DevicePin,
                points: [CGPoint]) {
        self.start = start
        self.end = end
        self.points = points
        
        Connection.count += 1
        id = "CONNECTION" + String(Connection.count)
    
        lineNode.path = Self.makePath(points: points)
        lineNode.strokeColor = SKColor.darkGray
        lineNode.lineWidth = 8
        lineNode.lineJoin = .round
        lineNode.lineCap = .round
        lineNode.zPosition = -10000
        lineNode.name = "CONNECTION"
        lineNode.userData = NSMutableDictionary()
        lineNode.userData?.setValue(self, forKey: "connection")
    }
    
    public static func == (lhs: Connection, rhs: Connection) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func makePath(points: [CGPoint]) -> CGMutablePath {
        let path = CGMutablePath()
        points.enumerated().forEach { (i, point) in
            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        return path
    }
    
    public func updateStartPoint(to point: CGPoint) {
        points[0] = point
        let path = Self.makePath(points: points)
        lineNode.path = path
    }
    
    public func updateEndPoint(to point: CGPoint) {
        let lastIndex = points.count - 1
        points[lastIndex] = point
        let path = Self.makePath(points: points)
        lineNode.path = path
    }
    
    public func updateColor() {
        lineNode.strokeColorTransition(to: state ? .canvasGreen : .canvasYellow, duration: 1/60)
    }
    
    public func resetColor() {
        lineNode.strokeColorTransition(to: .darkGray)
    }
}
