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
            
            
            //.background(Color(red: 0.25, green: 0.25, blue: 0.25))
            //.clipShape(RoundedRectangle(cornerRadius: 32))
            //.shadow(color: .black.opacity(configuration.isPressed ? 0.5 : 0), radius: configuration.isPressed ? 6 : 0, x: -4, y: 4)
    }
}
