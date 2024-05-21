import SwiftUI

struct BackdropView: View {
    
    // MARK: - Attibutes
    
    var imageLink: String
    var title: String
    var movieData: Movie
    var shouldHideButton: Bool = false
    
    // MARK: - View
    
    var body: some View {
        AsyncImage(url: URL(string: imageLink),
                         scale: 1) { image in
            
            ZStack(alignment: .bottom) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.linearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .center))
                    }
                
                VStack {
                    Text(title)
                        .fontWeight(.heavy)
                        .font(.system(shouldHideButton ? .largeTitle : .title))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black, radius: 4, x: 5, y: 5)
                    
                    NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieData: movieData))) {
                        Text("See details")
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background {
                                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                                    .foregroundStyle(.white)
                                    .opacity(0.1)
                            }
                            .buttonStyle(.bordered)
                            .padding(.bottom, 54)
                            .hidden(shouldHideButton)
                    }
                }
            }
        } placeholder: {
            Rectangle()
                .foregroundStyle(.darkGrey)
                .shimmering()
        }
    }
}

// MARK: - Preview

#Preview {
    BackdropView(imageLink: .empty, title: .empty, movieData: Movie())
        .background(Color.black)
}
