import SwiftUI

public struct CircleButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
             .foregroundColor(.white)
             .frame(width: 36, height: 36)
        
             .foregroundColor(.white)
             .background(
                 Circle()
                     .fill(configuration.isPressed ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color.clear)
                     .offset(x: 12, y:-12)
                     .blur(radius: 12)
                 
             )
             .background(Color(red: 0.25, green: 0.25, blue: 0.25))
             .clipShape(Circle())
             .hoverEffect(.lift)
             .shadow(color: .black.opacity(configuration.isPressed ? 0.5 : 0), radius: configuration.isPressed ? 6 : 0, x: -4, y: 4)
             .transaction { transaction in
                 transaction.animation = nil
             }
             .animation(.default, value: configuration.isPressed)
    }
}
