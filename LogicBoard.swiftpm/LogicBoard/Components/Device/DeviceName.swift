public enum DeviceName: String, Identifiable, Codable {
    case AND, NAND
    case OR, NOR
    case XOR, XNOR
    case NOT, BUFFER
    case PUSHBUTTON
    case DISPLAY
    
    public var id: String { deviceName }
    
    public var imageName: String {
        switch self {
        case .AND:
            return "AND"
        case .NAND:
            return "NAND"
        case .OR:
            return "OR"
        case .NOR:
            return "NOR"
        case .XOR:
            return "XOR"
        case .XNOR:
            return "XNOR"
        case .NOT:
            return "NOT"
        case .BUFFER:
            return "BUFFER"
        case .PUSHBUTTON:
            return "InputFalse"
        case .DISPLAY:
            return "OutputFalse"
        }
    }
    
    public var deviceName: String {
        switch self {
        case .AND:
            return "AND GATE"
        case .NAND:
            return "NAND GATE"
        case .OR:
            return "OR GATE"
        case .NOR:
            return "NOR GATE"
        case .XOR:
            return "XOR GATE"
        case .XNOR:
            return "XNOR GATE"
        case .NOT:
            return "NOT GATE"
        case .BUFFER:
            return "BUFFER"
        case .PUSHBUTTON:
            return "BUTTON"
        case .DISPLAY:
            return "DISPLAY"
        }
    }
    
    public static func deviceStringToDeviceName(string: String) -> DeviceName {
        switch string {
        case "AND GATE":
            return .AND
        case "NAND GATE":
            return .NAND
        case "OR GATE":
            return .OR
        case "NOR GATE":
            return .NOR
        case "XOR GATE":
            return .XOR
        case "XNOR GATE":
            return .XNOR
        case "NOT GATE":
            return .NOT
        case "BUFFER":
            return .BUFFER
        case "DISPLAY":
            return .DISPLAY
        default:
            return .PUSHBUTTON
        }
    }
    
    public func deviceNameToDevice() -> any Device {
        switch self {
        case .AND:
            return And()
        case .NAND:
            return Nand()
        case .OR:
            return Or()
        case .NOR:
            return Nor()
        case .XOR:
            return Xor()
        case .XNOR:
            return Xnor()
        case .NOT:
            return Not()
        case .BUFFER:
            return Buffer()
        case .DISPLAY:
            return Display()
        case .PUSHBUTTON:
            return PushButton()
        }
    }
}
