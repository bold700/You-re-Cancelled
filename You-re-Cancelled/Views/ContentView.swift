import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CancelViewModel()
    
    var body: some View {
        NavigationStack {
            MessageGeneratorView(viewModel: viewModel)
                .navigationTitle("Sorry, I can't make it... 🙈")
        }
    }
}

struct MessageGeneratorView: View {
    @ObservedObject var viewModel: CancelViewModel
    @State private var message = ""
    
    var body: some View {
        Form {
            MessageSectionView(message: $message)
            
            if !viewModel.availableGifs.isEmpty {
                GifSectionView(
                    gifs: viewModel.availableGifs,
                    selectedGif: viewModel.selectedGif
                ) { gif in
                    viewModel.selectedGif = gif
                } onLoadMore: {
                    viewModel.loadMoreGifs()
                }
            }
            
            if viewModel.isLoadingGifs {
                LoadingView(message: "Loading GIFs...")
            }
            
            if let error = viewModel.errorMessage {
                ErrorView(message: error)
            }
            
            GenerateButtonView(
                isDisabled: message.isEmpty,
                isLoading: viewModel.isDownloadingGif
            ) {
                viewModel.generateMessage(message)
            }
        }
        .onAppear {
            viewModel.loadInitialGifs()
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(items: viewModel.shareItems)
        }
    }
}

struct MessageSectionView: View {
    @Binding var message: String
    
    var body: some View {
        Section("Your message") {
            TextField("Type your message...", text: $message, axis: .vertical)
                .lineLimit(3...6)
            
            Button {
                withAnimation {
                    message = CancelExcuses.randomExcuse()
                }
            } label: {
                Text("Random Excuse")
            }
        }
    }
}

struct GifSectionView: View {
    let gifs: [GiphyService.GiphyGif]
    let selectedGif: GiphyService.GiphyGif?
    let onGifSelected: (GiphyService.GiphyGif) -> Void
    let onLoadMore: () -> Void
    
    var body: some View {
        Section("Choose a GIF") {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(gifs) { gif in
                        GifThumbnailView(
                            gif: gif,
                            isSelected: gif.id == selectedGif?.id,
                            onTap: { onGifSelected(gif) }
                        )
                        .id(gif.id)
                        .onAppear {
                            if gif.id == gifs.last?.id {
                                onLoadMore()
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 120)
            .listRowInsets(EdgeInsets())
        }
    }
}

struct GifThumbnailView: View {
    let gif: GiphyService.GiphyGif
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        AsyncImage(url: URL(string: gif.images.fixedWidth.url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 3)
                )
        } placeholder: {
            ProgressView()
                .frame(width: 100, height: 100)
        }
        .onTapGesture(perform: onTap)
    }
}

struct LoadingView: View {
    let message: String
    
    var body: some View {
        Section {
            HStack {
                Spacer()
                ProgressView(message)
                Spacer()
            }
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        Section {
            Text(message)
                .foregroundStyle(.secondary)
        }
    }
}

struct GenerateButtonView: View {
    let isDisabled: Bool
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Section {
            Button(action: action) {
                HStack {
                    Spacer()
                    if isLoading {
                        ProgressView()
                            .controlSize(.regular)
                            .tint(.white)
                    } else {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                        Text("Generate Message")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDisabled)
            .listRowInsets(EdgeInsets())
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 