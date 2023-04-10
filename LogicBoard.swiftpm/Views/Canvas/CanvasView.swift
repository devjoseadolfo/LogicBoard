import SwiftUI
import SpriteKit

public struct CanvasView: View {
    @EnvironmentObject var envi: LogicEnvironment
    @ObservedObject var canvasScene: CanvasScene
    
    public var body: some View {
        SpriteView(scene: canvasScene)
            .dropDestination(for: String.self) { items, location in
                guard let item = items.first else { return false }
                
                let deviceName = DeviceName.deviceStringToDeviceName(string: item)
                var device = deviceName.deviceNameToDevice()
                envi.board.selectedCircuit.add(&device, at: location)
                return true
            }
    }
}

public struct CanvasContainerView: View {
    @EnvironmentObject var envi: LogicEnvironment
    
    public var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: UIColor.lightGray))
                if envi.board.circuits.count == 0 {
                    Text("NO CIRCUIT IS SELECTED")
                        .font(.system(.body, design: .monospaced, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .padding(.horizontal, 4)
                        .background(.thinMaterial, in: Capsule())
                }
                ForEach(envi.board.circuits) { circuit in
                        CanvasView(canvasScene: circuit.canvasScene)
                            .opacity(envi.selectedCircuit == circuit ? 1 : 0)
                }
            }
            .background(Color(uiColor: UIColor.canvasBackground))
    }
}
