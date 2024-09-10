import SwiftUI

public struct InformationView: View {
    private let title: String
    private let info: String

    init(title: String, info: String) {
        self.title = title
        self.info = info
    }
    
    public var body: some View {
        HStack {
            Text(self.title)
                .padding()
                .foregroundColor(Color.InformationViewColor.TitleTint)
                .font(Font.custom("Lato", size: 10))
                .background(Color.InformationViewColor.Background)
            Spacer()
            Text(self.info)
                .padding()
                .foregroundColor(Color.InformationViewColor.InfoTint)
                .font(Font.custom("Lato", size: 10))
                .background(Color.InformationViewColor.Background)
        }
        .frame(height: 12)
        .background(Color.clear)
    }
}
