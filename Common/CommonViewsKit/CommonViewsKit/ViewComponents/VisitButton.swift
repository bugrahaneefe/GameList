import SwiftUI

public struct VisitButton: View {
    @State private var isActive: Bool
    private let name: String
    private let action: () -> Void
        
    public init(
        isActive: Bool = true,
        name: String,
        action: @escaping () -> Void
    ) {
        self.isActive = isActive
        self.name = name
        self.action = action
    }
    
    public var body: some View {
        VStack {
            Button(action: {
                self.action()
            }) {
                HStack {
                    Text(self.name)
                        .padding()
                        .foregroundColor(Color.VisitButtonViewColor.TitleTint)
                        .font(Font.custom("Lato", size: 12.0))
                        .frame(height: 14.0)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding()
                        .foregroundColor(Color.VisitButtonViewColor.TitleTint)
                        .font(Font.custom("Lato", size: 12.0))
                        .frame(height: 14.0)
                }
                .frame(height: 38)
                .background(Color.VisitButtonViewColor.Background)
            }
            .cornerRadius(8.0)
            .background(Color.clear)
            .disabled(!isActive)
        }
        .frame(height: 38)
        .background(.black)
    }
}
