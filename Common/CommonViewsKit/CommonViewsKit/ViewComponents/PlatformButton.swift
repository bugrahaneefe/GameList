import SwiftUI

public struct PlatformButton: View {
    @State private var isActive: Bool
    @State private var isSelected: Bool = false
    private let name: String
    private let action: () -> Void
        
    init(isActive: Bool = true, name: String, action: @escaping () -> Void) {
        self.isActive = isActive
        self.name = name
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
                        isSelected ? Color.PlatformButtonColor.Green :.white
                    )
                    .frame(height: 30)
                    .background(Color.PlatformButtonColor.Background)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.PlatformButtonColor.Green : .clear, lineWidth: 2))
            }
            .cornerRadius(15)
            .background(Color.clear)
            .disabled(!isActive)
    }
}
