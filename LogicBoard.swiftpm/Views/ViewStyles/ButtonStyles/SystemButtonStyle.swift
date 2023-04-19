import SwiftUI

public struct SystemButtonStyle: ButtonStyle {
    public var isChosen: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 32, height: 32, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .padding(8)
            .foregroundColor(.white)
            .background(
                Circle()
                    .fill(isChosen ? Color(red: 0.0, green: 0.52, blue: 1.0) : Color.clear)
                    .offset(x: 12, y:-12)
                    .blur(radius: 12)
                
            )
            .background(isChosen ? Color(red: 0.0, green: 0.14, blue: 1.0) : Color(red: 0.25, green: 0.25, blue: 0.25))
            .clipShape(Circle())
            .animation(.easeIn, value: isChosen)
            .shadow(color: Color(red: 0.0, green: 0.4, blue: 1.0).opacity(isChosen ? 0.3 : 0),
                    radius: 10,
                    x: 5,
                    y: -5)
            .shadow(color: .black.opacity(isChosen ? 0.5 : 0),
                    radius: 8,
                    x: -4,
                    y: 4)
            
    }
}
