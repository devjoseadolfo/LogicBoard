import SwiftUI

public struct ActionLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .font(.system(size: 16, weight: .regular, design: .default))
                .frame(width: 12, height: 12)
                .padding(4)
                .padding(.leading, 2)
            
            configuration.title
                .fixedSize()
                .lineLimit(1)
                .font(.system(size: 13, weight: .regular, design: .default))
                .padding(.trailing, 4)
        }
    }
}
