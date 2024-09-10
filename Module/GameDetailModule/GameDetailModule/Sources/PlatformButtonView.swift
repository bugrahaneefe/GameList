import SwiftUI

public struct PlatformButtonView: View {
    public var buttonAction: (Int) -> Void
    
    public init(buttonAction: @escaping (Int) -> Void) {
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                Button(action: {buttonAction(1)}) {
                    Text("Solid Button")
                        .padding()
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                }
                Button(action: {buttonAction(2)}) {
                    Text("Solid Button")
                        .padding()
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                }
                Button(action: {buttonAction(3)}) {
                    Text("Solid Button")
                        .padding()
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                }
                Button(action: {buttonAction(4)}) {
                    Text("Solid Button")
                        .padding()
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                }
            }
        }
    }
}
