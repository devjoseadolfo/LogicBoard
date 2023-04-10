import SwiftUI
import UniformTypeIdentifiers

public struct ActionControlView: View {
    @EnvironmentObject var envi: LogicEnvironment
    @ObservedObject var circuit: Circuit
    @State var showInfo: Bool = false
    let wireHelp: String = "To draw a wire, drag from one pin to another pin. To make a turn in the wire, pause momentarily while dragging or, if using an Apple Pencil, press hard on the screen."
    let addHelp: String = "To add a device, drag your chosen device from the right panel and drop it to the desire location on the circuit."
    
    @State var importing = false
    @State var exporting = false
    @State var showImportErrorAlert = false
    @State var showExportErrorAlert = false
    @State var showExportSuccessAlert = false
    
    public var body: some View {
        HStack(spacing: 0) {
            if circuit.state == .file {
                Button {
                   importing = true
                } label: {
                    Label("Import", systemImage: "square.and.arrow.down")
                        .labelStyle(ActionLabelStyle())
                }
                .buttonStyle(ActionButtonStyle())
                
                Divider()
                    .frame(height: 20)
                
                Button {
                    exporting = true
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                        .labelStyle(ActionLabelStyle())
                }.buttonStyle(ActionButtonStyle())
                
            }
            if circuit.state == .wire || circuit.state == .add {
                if let device = circuit.selectedDevice {
                    Button {
                        let position: CGPoint = .init(x: device.spriteNode.position.x + (device.imageNode.size.width * 1.25),
                                                      y: device.spriteNode.position.y)
                        
                        var newDevice: any Device = DeviceName.deviceStringToDeviceName(string: device.deviceName).deviceNameToDevice()
                        circuit.add(&newDevice, at: position)
                        
                        newDevice.spriteNode.position = position
                    } label: {
                        Label("Duplicate", systemImage: "plus.square.on.square")
                            .labelStyle(ActionLabelStyle())
                    }
                    .buttonStyle(ActionButtonStyle())
                    Divider()
                        .frame(height: 20)
                    Button {
                        circuit.remove(device)
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .labelStyle(ActionLabelStyle())
                    }
                    .buttonStyle(ActionButtonStyle())
                } else if let connection = circuit.selectedConnection {
                    Button {
                        circuit.remove(connection)
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .labelStyle(ActionLabelStyle())
                    }
                    .buttonStyle(ActionButtonStyle())
                } else {
                    Button {
                        showInfo = true
                    } label: {
                        Label("Help", systemImage: "questionmark.circle")
                            .labelStyle(ActionLabelStyle())
                    }
                    .buttonStyle(ActionButtonStyle())
                    .alwaysPopover(isPresented: $showInfo, content: {
                        Text(circuit.state == .wire ? wireHelp : addHelp)
                            .frame(maxWidth: 300)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .font(.system(size: 13, weight: .regular, design: .default))
                            .multilineTextAlignment(.leading)
                            .padding(20)
                    })
                }
            }
            
            if circuit.state == .simulate {
                Button {
                    circuit.perLevelSolve()
                } label: {
                    Label("Next Step", systemImage: "forward")
                        .labelStyle(ActionLabelStyle())
                }
                .buttonStyle(ActionButtonStyle())
                Divider()
                    .frame(height: 20)
                Button {
                    circuit.hardReset()
                } label: {
                    Label("Reset", systemImage: "gobackward")
                        .labelStyle(ActionLabelStyle())
                }
                .buttonStyle(ActionButtonStyle())
            }            
            
        }
       
        .background(.thinMaterial, in: Capsule())
        .clipShape(Capsule())
        .transaction { transaction in
            transaction.animation = .easeInOut
        }
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: [.circ, .json, .init(filenameExtension: "circ")!]
        ) { result in
            do {
                let url: URL = try result.get()
                let _ = url.startAccessingSecurityScopedResource()
                let jsonData = try Data(contentsOf: url)
                url.stopAccessingSecurityScopedResource()
                let decoder = JSONDecoder()
                let circuitData = try decoder.decode(CircuitData.self, from: jsonData)
                let newCircuit = circuitData.makeCircuit()
                envi.board.addCircuit(newCircuit)
                envi.selectedCircuit = newCircuit
            } catch {
                showImportErrorAlert = true
            }
        }
        .fileExporter(isPresented: $exporting,
                      document: CircuitDocument(circuitData: circuit.makeCircuitData()),
                      contentType: .circ,
                      defaultFilename: circuit.name + ".circ",
                      onCompletion: { result in 
            switch result {
            case .success:
                showExportSuccessAlert = true
            case .failure:
                showExportErrorAlert = true
            }
        })
        .alert("Unable to import .circ file.", isPresented: $showImportErrorAlert) {
            Button("OK", role: .cancel) {
                showImportErrorAlert = false
            }
        }
        .alert("Unable to export .circ file.", isPresented: $showExportErrorAlert) {
            Button("OK", role: .cancel) {
                showExportErrorAlert = false
            }
        }
        .alert("The .circ file was exported successfully.", isPresented: $showExportSuccessAlert) {
            Button("OK", role: .cancel) {
                showExportSuccessAlert = false
            }
        }
    }
}
