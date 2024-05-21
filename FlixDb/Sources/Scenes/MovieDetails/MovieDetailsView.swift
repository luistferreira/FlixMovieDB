import SwiftUI
import CachedAsyncImage

struct MovieDetailsView: View {
    
    // MARK: - Attirbutes
    
    @StateObject var viewModel: MovieDetailsViewModel
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            
            if viewModel.state == .error {
                ErrorView(action: fetchData)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 48){
                        BackdropView(imageLink: viewModel.createBackdropPath(viewModel.movieData),
                                     title: viewModel.movieData.title ?? .empty, movieData: viewModel.movieData,shouldHideButton: true)
                        .frame(height: 500)
                        
                        castGridView
                        
                        moreImagesView
                    }
                }
                .ignoresSafeArea(edges: .top)
                .toolbarBackground(.hidden, for: .navigationBar)
                .onAppear(perform: fetchData)
            }
        }
    }
    
    // MARK: - Subviews
    
    var castGridView: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.leading, 16)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                if let cast = viewModel.movieDetails?.cast {
                    ForEach(cast, id: \.id) { movie in
                        CastView(name: movie.name ?? .empty,
                                 imageLink: viewModel.createCastPath(movie))
                    }
                }
            }
        }
    }
    
    var moreImagesView: some View {
        VStack(alignment: .leading) {
            Text("More images")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            TabView {
                ForEach(viewModel.movieImages, id: \.filePath) {
                    AsyncImage(url: URL(string: viewModel.createBackdrops($0)),
                                     scale: 1) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.darkGrey)
                            .shimmering()
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
            .frame(width: 350, height: 200)
            .tabViewStyle(.page(indexDisplayMode: .always))
            Spacer()
        }
    }
    
    func fetchData() {
        Task {
            await viewModel.fetchMovieData()
        }
    }
}

// MARK: - Preview

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(movieData: Movie()))
}
