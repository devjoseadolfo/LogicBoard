import SwiftUI

public struct ActionButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary)
            .hoverEffect(.highlight)
            .padding(4)
            .padding(.horizontal, 4)
            .background(
                Capsule()
                    .fill(configuration.isPressed ? Color.primary.opacity(0.3) : Color.clear)
            )
            .padding(4)
    }
}
