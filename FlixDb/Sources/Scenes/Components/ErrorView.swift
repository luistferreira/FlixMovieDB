import SwiftUI

struct ErrorView: View {
    
    // MARK: - Attributes
    
    var action: () -> Void
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("Something's wrong :(")
                .font(.system(size: 50))
                .fontWeight(.heavy)
            
            Text("Do you wanna try again?")
                .font(.title2)
            
            Spacer()
            
            Button("Refresh", systemImage: "arrow.clockwise", action: action)
                .buttonStyle(.bordered)
                .tint(.white)
                .font(.title2)
        }
        .padding()
        .padding(.vertical, 36)
        .foregroundStyle(.white)
    }
}

// MARK: - Preview

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        ErrorView(action: { })
    }
    .background(Color.black)
}

