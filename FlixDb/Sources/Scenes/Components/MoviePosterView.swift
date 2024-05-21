import SwiftUI
import CachedAsyncImage

struct MoviePosterView: View {
    
    // MARK: - Attributes
    
    var title: String
    var imageLink: String
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            
            
            CachedAsyncImage(url: URL(string: imageLink),
                             transaction: .init(animation: .easeOut)) { AsyncImagePhase in
                switch AsyncImagePhase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                        .frame(height: 160)
                default:
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 110, height: 160)
                        .foregroundStyle(.darkGrey)
                        .shimmering()
                }
            }
            
            Text(title)
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

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        MoviePosterView(title: "Movie title", imageLink: "link")
    }
    .background(Color.black)
}
