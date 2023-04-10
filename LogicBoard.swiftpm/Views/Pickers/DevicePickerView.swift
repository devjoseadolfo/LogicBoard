import SwiftUI

public struct DevicePickerView: View {
    var deviceNames: [DeviceName] = [.PUSHBUTTON, .DISPLAY, .AND, .NAND, .OR, .NOR, .XOR, .XNOR, .NOT, .BUFFER]
    
    public var body: some View {
        ScrollView(.vertical ,showsIndicators: false) {
            VStack{
                ForEach(deviceNames) { deviceName in
                    DeviceView(deviceName: deviceName)
                }
            }
            .frame(width: 100)
            .padding(10)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxHeight: 800)
    }
}

struct DeviceView: View {
    var deviceName: DeviceName
    
    var body: some View {
        VStack {
            Image(deviceName.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(deviceName.deviceName)
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .padding(4)
                .padding(.horizontal, 4)
                .background(Color(red: 0.4, green: 0.4, blue: 0.4), in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(8)
        .background(Color(red: 0.25, green: 0.25, blue: 0.25), in: RoundedRectangle(cornerRadius: 12))
        .draggable(deviceName.deviceName) {
            Image(deviceName.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 100)
        }
        .hoverEffect(.lift)
    }
}
