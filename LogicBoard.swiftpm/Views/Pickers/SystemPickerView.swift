import SwiftUI

struct SystemPickerView: View {
    @EnvironmentObject var envi: LogicEnvironment
    @ObservedObject var circuit: Circuit
    var body: some View {
        VStack() {
            Spacer()
            VStack() {
                Spacer()
                VStack {
                    Button {
                        circuit.state = .file
                    } label: {
                        Label("File Picker", systemImage: "doc.fill")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(SystemButtonStyle(isChosen: circuit.state  == .file))
                    .keyboardShortcut("s", modifiers: .command)
                    
                    Button {
                        circuit.state = .add
                    } label: {
                        Label("Add", systemImage: "memorychip")
                            .rotationEffect(.degrees(90))
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .font(.system(size: 20, weight: .bold))
                        
                    }
                    .buttonStyle(SystemButtonStyle(isChosen: circuit.state  == .add))
                    .keyboardShortcut("a", modifiers: .command)
 
                    Button {
                        circuit.state  = .wire
                    } label: {
                        Label("Wire", systemImage: "app.connected.to.app.below.fill")
                            .rotationEffect(.degrees(90))
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .keyboardShortcut("w", modifiers: .command)
                    .buttonStyle(SystemButtonStyle(isChosen: circuit.state == .wire))
                    
                    Button {
                        circuit.state = .simulate
                    } label: {
                        Label("Simulate", systemImage: "play.fill")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(SystemButtonStyle(isChosen: circuit.state == .simulate))
                    .keyboardShortcut(.defaultAction)
                    
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 100, height: 100)))
                .frame(alignment: .leading)
                
                
                Spacer()
                
                Button {
                    envi.showDock.toggle()
                } label: {
                    Label("", systemImage: "rectangle.stack.fill")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .font(.system(size: 20))
                }
                .buttonStyle(SystemButtonStyle(isChosen: envi.showDock))
                .keyboardShortcut("b")
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerSize: .init(width: 100, height: 100)))
                .frame(alignment: .bottomLeading)
                
            }
        }
    }
}

