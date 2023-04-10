import SwiftUI

public struct CircuitPickerView: View {
    @EnvironmentObject var envi: LogicEnvironment
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach($envi.board.circuits) { $circuit in
                    CircuitPickerUnitView(circuit: $circuit)
                }
                Button {
                    envi.board.addCircuit()
                } label: {
                    Label("Add Circuit", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 20, weight: .bold))
                }
                .buttonStyle(CircleButtonStyle())
                
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}


struct CircuitPickerUnitView: View {
    @EnvironmentObject var envi: LogicEnvironment
    @Binding var circuit: Circuit 
    @State var showRename: Bool = false
    @State var newName: String = ""
    @State var showDelete: Bool = false
    
    var body: some View {
        Button {
            envi.selectedCircuit = circuit
        } label: {
            Text(circuit.name.uppercased())
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .lineLimit(1)
                .fixedSize()

        }
        .buttonStyle(CircuitButtonStyle(isChosen: envi.selectedCircuit == circuit))
        .contextMenu(menuItems: {
            Button {
                showRename = true
                newName = circuit.name
            } label: {
                Label("Rename", systemImage: "text.cursor")
            }.disabled(circuit.isExample)
            Button(role: .destructive) {
                showDelete = true
            } label: {
                Label("Delete", systemImage: "trash")
            }.disabled(circuit.isExample)
        })
        .shadow(color: .black.opacity(envi.selectedCircuit == circuit ? 0.5 : 0), radius: envi.selectedCircuit == circuit ? 8 : 0, x: -4, y: 4)
        .alert("Rename Circuit", isPresented: $showRename, actions: {
            TextField(circuit.name, text: $newName)
            Button("Cancel", role: .cancel) {
                showRename = false
            }
            Button("Rename") {
                circuit.name = newName
                newName = ""
                showRename = false
            }
        }, message: {
            Text("Enter the new name for " + circuit.name)
        })
        .alert("Delete Circuit", isPresented: $showDelete, actions: {
            Button("Cancel", role: .cancel) {
                showDelete = false
            }
            Button("Delete", role: .destructive) {
                envi.board.removeCircuit(circuit)
                envi.selectedCircuit = envi.board.mainCircuit
                showDelete = false
            }
        }, message: {
            Text("Are you sure you want to delete " + circuit.name + "?")
        })
    }
}
