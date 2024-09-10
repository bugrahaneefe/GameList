import SwiftUI

public struct PlatformButton: View {
    @State private var isActive: Bool
    @State private var isSelected: Bool = false
    private let name: String
    private let fontSize: CGFloat
    private let height: CGFloat
    private let cellRadius: CGFloat
    private let defaultColor: Color
    private let action: () -> Void
        
    init(
        isActive: Bool = true,
        name: String,
        fontSize: CGFloat,
        height: CGFloat,
        cellRadius: CGFloat,
        defaultColor: Color,
        action: @escaping () -> Void
    ) {
        self.isActive = isActive
        self.name = name
        self.fontSize = fontSize
        self.height = height
        self.cellRadius = cellRadius
        self.defaultColor = defaultColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            self.action()
            isSelected.toggle()
        }) {
                Text(self.name)
                    .padding()
                    .foregroundColor(
                        isSelected ? Color.PlatformButtonColor.Green : defaultColor
                    )
                    .font(Font.custom("Lato", size: fontSize))
                    .frame(height: height)
                    .background(Color.PlatformButtonColor.Background)
                    .overlay(RoundedRectangle(cornerRadius: cellRadius)
                        .stroke(isSelected ? Color.PlatformButtonColor.Green : .clear, lineWidth: 2))
            }
            .cornerRadius(cellRadius)
            .background(Color.clear)
            .disabled(!isActive)
    }
}
