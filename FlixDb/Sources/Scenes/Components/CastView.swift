import SwiftUI
import CachedAsyncImage

struct CastView: View {

    // MARK: - Attibutes

    @State var name: String
    @State var imageLink: String
    
    // MARK: - View

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            CachedAsyncImage(url: URL(string: imageLink),
                           transaction: .init(animation: .easeOut)) { AsyncImagePhase in
                    switch AsyncImagePhase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                        
                    case .failure(_):
                        Circle()
                            .frame(width: 110, height: 110)
                            .foregroundStyle(.darkGrey)
                            .shimmering()
                            
                    default:
                        Circle()
                            .frame(width: 110, height: 110)
                            .foregroundStyle(.darkGrey)
                            .shimmering()
                    }
            }
            
            Text(name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.lightGrey)
                .lineLimit(2)
                .truncationMode(.tail)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    CastView(name: .empty, imageLink: .empty)
}
