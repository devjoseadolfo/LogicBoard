import SpriteKit

extension Circuit {
    static func simpleOr() -> Circuit{
        let button1Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -300, y: 100))
        let button2Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -300, y: -100))
        let orData = DeviceData(deviceName: .OR,
                             location: .init(x: 0, y: 0))
        let displayData = DeviceData(deviceName: .DISPLAY,
                                 location: .init(x: 300, y: 0))
        
        let devices = [button1Data, button2Data, orData, displayData]
        
        let connection1Data = ConnectionData(points: [CGPoint(x: -236, y: 100),
                                                      CGPoint(x: -182, y: 100),
                                                      CGPoint(x: -182, y: 64),
                                                      CGPoint(x: -128, y: 64)])
        let connection2Data = ConnectionData(points: [CGPoint(x: -236, y: -100),
                                                      CGPoint(x: -182, y: -100),
                                                      CGPoint(x: -182, y: -64),
                                                      CGPoint(x: -128, y: -64)])
        let connection3Data = ConnectionData(points: [CGPoint(x: 128, y: 0),
                                                      CGPoint(x: 236, y: 0)])
    
        let connections: [ConnectionData] = [connection1Data, connection2Data, connection3Data]
        
        let circuitData = CircuitData(name: "OR GATE", deviceDatas: devices, connectionData: connections)
        
        return circuitData.makeCircuit()
    }

    static func fullAdder() -> Circuit{
        let button1Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -448, y: 272))
        let button2Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -448, y: 144))
        let button3Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -448, y: -300))
        let xor1Data = DeviceData(deviceName: .XOR,
                             location: .init(x: 192, y: 144))
        let xor2Data = DeviceData(deviceName: .XOR,
                             location: .init(x: -136, y: 208))
        let and1Data = DeviceData(deviceName: .AND,
                             location: .init(x: 192, y: -36))
        let and2Data = DeviceData(deviceName: .AND,
                             location: .init(x: -132, y: -36))
        let norData = DeviceData(deviceName: .OR,
                             location: .init(x: 192, y: -296))
        let display1Data = DeviceData(deviceName: .DISPLAY,
                                 location: .init(x: 456, y: 144))
        let display2Data = DeviceData(deviceName: .DISPLAY,
                                 location: .init(x: 456, y: -296))
        
        let devices = [button1Data,
                       button2Data,
                       button3Data,
                       xor1Data,
                       xor2Data,
                       and1Data,
                       and2Data,
                       norData,
                       display1Data,
                       display2Data]
        
        

        let connection1Data = ConnectionData(points: [CGPoint(x: -384, y: 144),
                                                      CGPoint(x: -264, y: 144)])
        
        let connection2Data = ConnectionData(points: [CGPoint(x: -384, y: 272),
                                                      CGPoint(x: -264, y: 272)])
        
        let connection3Data = ConnectionData(points: [CGPoint(x: -8, y: 208),
                                                      CGPoint(x: 64, y: 208)])
        
        let connection4Data = ConnectionData(points: [CGPoint(x: -384, y: 272),
                                                      CGPoint(x: -322, y: 272),
                                                      CGPoint(x: -322, y: 28),
                                                      CGPoint(x: -260, y: 28)])
        
        let connection5Data = ConnectionData(points: [CGPoint(x: -384, y: 144),
                                                      CGPoint(x: -384, y: -100),
                                                      CGPoint(x: -260, y: -100)])
        
        let connection6Data = ConnectionData(points: [CGPoint(x: -4, y: -36),
                                                      CGPoint(x: -4, y: -360),
                                                      CGPoint(x: 64, y: -360)])
        
        let connection7Data = ConnectionData(points: [CGPoint(x: 320, y: -296),
                                                      CGPoint(x: 392, y: -296)])
        
        let connection8Data = ConnectionData(points: [CGPoint(x: 320, y: 144),
                                                      CGPoint(x: 392, y: 144)])
        
        let connection9Data = ConnectionData(points: [CGPoint(x: 320, y: -36),
                                                      CGPoint(x: 320, y: -166 ),
                                                      CGPoint(x: 64, y: -166),
                                                      CGPoint(x: 64, y: -232)])
        
        let connection10Data = ConnectionData(points: [CGPoint(x: -384, y: -300),
                                                      CGPoint(x: 30, y: -300),
                                                      CGPoint(x: 30, y: 80),
                                                      CGPoint(x: 64, y: 80)])
        
        let connection11Data = ConnectionData(points: [CGPoint(x: -8, y: 208),
                                                       CGPoint(x: -8, y: 28),
                                                      CGPoint(x: 64, y: 28)])
        
        let connection12Data = ConnectionData(points: [CGPoint(x: -384, y: -300),
                                                       CGPoint(x: 30, y: -300),
                                                       CGPoint(x: 30, y: -100),
                                                       CGPoint(x: 64, y: -100)])
        
    
        let connections: [ConnectionData] = [connection1Data,
                                             connection2Data,
                                             connection3Data,
                                             connection4Data,
                                             connection5Data,
                                             connection6Data,
                                             connection7Data,
                                             connection8Data,
                                             connection9Data,
                                             connection10Data,
                                             connection11Data,
                                             connection12Data]
        
        let circuitData = CircuitData(name: "FULL ADDER", deviceDatas: devices, connectionData: connections)
        
        return circuitData.makeCircuit()
    }
    
    static func dLatch() -> Circuit{
        let y = CGFloat(64)
        
        let button1Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -496, y: 36 - y))
        let button2Data = DeviceData(deviceName: .PUSHBUTTON,
                                 location: .init(x: -496, y: 312 - y))
        let notData = DeviceData(deviceName: .NOT,
                             location: .init(x: -316, y: 312 - y))
        let and1Data = DeviceData(deviceName: .AND,
                             location: .init(x: -72, y: 248 - y))
        let and2Data = DeviceData(deviceName: .AND,
                             location: .init(x: -72, y: -176 - y))
        let nor1Data = DeviceData(deviceName: .NOR,
                             location: .init(x: 240, y: 184 - y))
        let nor2Data = DeviceData(deviceName: .NOR,
                             location: .init(x: 240, y: -112 - y))
        let display1Data = DeviceData(deviceName: .DISPLAY,
                                 location: .init(x: 488, y: 184 - y))
        let display2Data = DeviceData(deviceName: .DISPLAY,
                                 location: .init(x: 488, y: -112 - y))
        
        let devices = [button1Data,
                       button2Data,
                       notData,
                       and1Data,
                       and2Data,
                       nor1Data,
                       nor2Data,
                       display1Data,
                       display2Data]

        let connection1Data = ConnectionData(points: [CGPoint(x: -432, y: 312 - y),
                                                      CGPoint(x: -380, y: 312 - y)])
        
        let connection2Data = ConnectionData(points: [CGPoint(x: -252, y: 312 - y),
                                                      CGPoint(x: -200, y: 312 - y)])
        
        let connection3Data = ConnectionData(points: [CGPoint(x: -432, y: 36 - y),
                                                      CGPoint(x: -200, y: 36 - y),
                                                      CGPoint(x: -200, y: 184 - y)])
        
        let connection4Data = ConnectionData(points: [CGPoint(x: -432, y: 36 - y),
                                                      CGPoint(x: -200, y: 36 - y),
                                                      CGPoint(x: -200, y: -112 - y)])
        
        let connection5Data = ConnectionData(points: [CGPoint(x: -432, y: 312 - y),
                                                      CGPoint(x: -406, y: 312 - y),
                                                      CGPoint(x: -406, y: -240 - y),
                                                      CGPoint(x: -200, y: -240 - y)])
        
        let connection6Data = ConnectionData(points: [CGPoint(x: 56, y: 248 - y),
                                                      CGPoint(x: 112, y: 248 - y)])
        
        let connection7Data = ConnectionData(points: [CGPoint(x: 56, y: -176 - y),
                                                      CGPoint(x: 112, y: -176 - y)])
        
        let connection8Data = ConnectionData(points: [CGPoint(x: 368, y: 184 - y),
                                                      CGPoint(x: 368, y: 152 - y),
                                                      CGPoint(x: 112, y: -16 - y),
                                                      CGPoint(x: 112, y: -48 - y)])
        
        let connection9Data = ConnectionData(points: [CGPoint(x: 368, y: -112 - y),
                                                      CGPoint(x: 368, y: -80 - y),
                                                      CGPoint(x: 112, y: 88 - y),
                                                      CGPoint(x: 112, y: 120 - y)])
        
        let connection10Data = ConnectionData(points: [CGPoint(x: 368, y: 184 - y),
                                                       CGPoint(x: 424, y: 184 - y)])
        
        let connection11Data = ConnectionData(points: [CGPoint(x: 368, y: -112 - y),
                                                       CGPoint(x: 424, y: -112 - y)])
        
    
        let connections: [ConnectionData] = [connection1Data,
                                             connection2Data,
                                             connection3Data,
                                             connection4Data,
                                             connection5Data,
                                             connection6Data,
                                             connection7Data,
                                             connection8Data,
                                             connection9Data,
                                             connection10Data,
                                             connection11Data]
        
        let circuitData = CircuitData(name: "D LATCH", deviceDatas: devices, connectionData: connections)
        
        return circuitData.makeCircuit()
    }
}
