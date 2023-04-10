import SwiftUI

struct BoardView: View {
    @EnvironmentObject var envi: LogicEnvironment
    var body: some View {
        ZStack{
            CanvasContainerView()
                .animation(.easeInOut(duration: 0.2), value: envi.board.selectedCircuit)
            CircuitView(circuit: envi.selectedCircuit)
        }
    }
}

struct CircuitView: View {
    @EnvironmentObject var envi: LogicEnvironment
    @ObservedObject var circuit: Circuit
    
    var body: some View {
        ZStack {
            VStack {
                ActionControlView(circuit: envi.selectedCircuit)
                    .padding([.top, .horizontal], 20)
                    .animation(.easeInOut, value: circuit.state)
              Spacer()
                if envi.showDock {
                    HStack {
                        CircuitPickerView()
                            .padding([.bottom, .horizontal], 24)
                            .padding(.leading, 84)
                            .transition(.opacity)
                        Spacer()
                    }
                }
            }
            .animation(.easeInOut, value: envi.showDock)
            .animation(.easeInOut, value: envi.board.selectedCircuit)
            .animation(.easeInOut, value: envi.board.circuits)
            .animation(.easeInOut, value: circuit.state)
    
            HStack {
                SystemPickerView(circuit: circuit)
                    .frame(maxWidth: 64, alignment: .leading)
                    .padding(20)
                Spacer()
                if circuit.state == .add {
                    DevicePickerView()
                        .padding([.trailing], 20)
                        .padding([.vertical], 100)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: circuit.state)

        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(LogicEnvironment())
        }
}
