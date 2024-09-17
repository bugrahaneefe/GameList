import SwiftUI

public struct PlatformButton: View {
    @Binding private var isSelected: Bool
    @State private var isActive: Bool
    private let name: String
    private let fontSize: CGFloat
    private let height: CGFloat
    private let cellRadius: CGFloat
    private let defaultColor: Color
    private let action: () -> Void
        
    init(
        isActive: Bool = true,
        isSelected: Binding<Bool> = .constant(false),
        name: String,
        fontSize: CGFloat,
        height: CGFloat,
        cellRadius: CGFloat,
        defaultColor: Color,
        action: @escaping () -> Void
    ) {
        self.isActive = isActive
        self._isSelected =  isSelected
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
