import SwiftUI
import Shimmer

struct HomeView: View {
    
    // MARK: - Attributes
    
    @StateObject var viewModel: HomeViewModel
    
    // MARK: - View
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()
            
            if viewModel.state == .error {
                ErrorView(action: { fetchBySegmentedState(viewModel.segmentedControl) })
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        top3MoviestabView
                            .overlay { sectionPickerView }
                        
                        switch viewModel.segmentedControl {
                        case .popular:
                            popularMovieGridView
                        case .upcoming:
                            upcomingMovieGridView
                        case .topRated:
                            topMovieGridView
                        }
                    }
                    .animation(.easeInOut, value: viewModel.segmentedControl)
                }
                .ignoresSafeArea(edges: .top)
            }
    
        }
        .onChange(of: viewModel.segmentedControl) { _, state in
           fetchBySegmentedState(state)
        }
    }
    
    // MARK: - Subviews
    
    var top3MoviestabView: some View {
        TabView {
            ForEach(viewModel.top3Movies, id: \.id) { movieData in
                BackdropView(imageLink: viewModel.createBackdropPath(movieData),
                             title: movieData.title ?? .empty,
                             movieData: movieData)
                .tag(movieData.backdropPath)
            }
        }
        .frame(height: 500)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    var sectionPickerView: some View {
        VStack {
            Picker("selection", selection: $viewModel.segmentedControl) {
                ForEach(viewModel.segmentedControlList,  id: \.self) {
                    Text($0.title)
                        .tag(viewModel.segmentedControlList.firstIndex(of: $0))
                }
            }
            .background(Color.gray.opacity(1).blur(radius: 20))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            .pickerStyle(.segmented)
            .padding(.top, 64)
            .padding()
            Spacer()
        }
    }
    
    var popularMovieGridView: some View {
        VStack(alignment: .leading) {
            Text("Popular")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            MovieGridView(movieData: $viewModel.popularMoviesData, performFetch: { fetchBySegmentedState(.popular) })
                .padding(.horizontal, 8)
        }
        .onAppear {
            if viewModel.popularMoviesData.isEmpty {
                fetchBySegmentedState(.popular)
            }
        }
    }
    
    var upcomingMovieGridView: some View {
        VStack(alignment: .leading) {
            Text("Upcoming")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            MovieGridView(movieData: $viewModel.upcomingMoviesData, performFetch: { fetchBySegmentedState(.upcoming) })
                .padding(.horizontal, 8)
        }
    }
    
    var topMovieGridView: some View {
        VStack(alignment: .leading) {
            Text("Top Rated")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            MovieGridView(movieData: $viewModel.topMoviesData, performFetch: { fetchBySegmentedState(.topRated) })
                .padding(.horizontal, 8)
        }
    }
}

// MARK: - Methods

extension HomeView {
    
    private func fetchBySegmentedState(_ state: MovieListType) {
        Task {
            switch state {
            case .popular:
                 await viewModel.fetchMovieData(.popular)
            case .upcoming:
                 await viewModel.fetchMovieData(.upcoming)
            case .topRated:
                 await viewModel.fetchMovieData(.topRated)
            }
            viewModel.switchTop3Movies()
        }
    }
}

// MARK: - Methods

#Preview {
    HomeView(viewModel: HomeViewModel())
}
