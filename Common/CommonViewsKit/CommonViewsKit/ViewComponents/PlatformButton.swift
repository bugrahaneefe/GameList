import SwiftUI

public struct PlatformButton: View {
    @Binding private var isSelected: Bool
    @State private var isActive: Bool
    private let name: String
    private let fontSize: CGFloat
    private let horizontalPadding: CGFloat
    private let height: CGFloat
    private let cellRadius: CGFloat
    private let defaultColor: Color
    private let action: () -> Void
        
    init(
        isActive: Bool = true,
        isSelected: Binding<Bool> = .constant(false),
        name: String,
        fontSize: CGFloat,
        horizontalPadding: CGFloat = 12,
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
        self.horizontalPadding = horizontalPadding
    }
    
    public var body: some View {
        Button(action: {
            self.action()
        }) {
                Text(self.name)
                    .frame(height: height)
                    .padding(.vertical, 4)
                    .padding(.horizontal, horizontalPadding)
                    .foregroundColor(
                        isSelected ? Color.PlatformButtonColor.Green : defaultColor
                    )
                    .font(Font.custom("Lato", size: fontSize))
                    .background(Color.PlatformButtonColor.Background)
                    .overlay(RoundedRectangle(cornerRadius: cellRadius)
                        .stroke(isSelected ? Color.PlatformButtonColor.Green : .clear, lineWidth: 2))
            }
            .cornerRadius(cellRadius)
            .background(Color.clear)
            .disabled(!isActive)
    }
}
