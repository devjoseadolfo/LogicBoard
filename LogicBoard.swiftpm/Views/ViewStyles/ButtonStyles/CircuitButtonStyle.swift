import SwiftUI

public struct CircuitButtonStyle: ButtonStyle {
    public var isChosen: Bool
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 8)
            .padding(8)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isChosen ? Color(red: 0.0, green: 0.52, blue: 1.0) : Color.clear)
                    .offset(x: 12, y:-12)
                    .blur(radius: 16)
            )
            .background(isChosen ? Color(red: 0.0, green: 0.14, blue: 1.0) : Color(red: 0.25, green: 0.25, blue: 0.25))
            .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}
