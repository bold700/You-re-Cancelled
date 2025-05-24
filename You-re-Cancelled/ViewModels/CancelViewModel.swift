import SwiftUI

@MainActor
class CancelViewModel: ObservableObject {
    @Published var showNewMessage = false
    @Published var generatedMessage: CancelMessage?
    @Published var showShareSheet = false
    @Published var availableGifs: [GiphyService.GiphyGif] = []
    @Published var selectedGif: GiphyService.GiphyGif?
    @Published var isLoadingGifs = false
    @Published var isDownloadingGif = false
    @Published var errorMessage: String?
    @Published var shareItems: [Any] = []
    
    private let giphyService = GiphyService()
    private var isLoadingMore = false
    
    func loadInitialGifs() {
        Task {
            do {
                isLoadingGifs = true
                errorMessage = nil
                selectedGif = nil
                availableGifs = try await giphyService.searchGifs(for: "funny excuse meme")
                if availableGifs.isEmpty {
                    errorMessage = "No GIFs found. Please try again!"
                }
            } catch {
                errorMessage = "Failed to load GIFs. Please try again."
            }
            isLoadingGifs = false
        }
    }
    
    func loadMoreGifs() {
        guard !isLoadingMore else { return }
        
        Task {
            do {
                isLoadingMore = true
                let newGifs = try await giphyService.searchGifs(for: "funny excuse meme", loadMore: true)
                availableGifs.append(contentsOf: newGifs)
            } catch {
                // Silently fail when loading more
                print("Failed to load more GIFs: \(error)")
            }
            isLoadingMore = false
        }
    }
    
    func generateMessage(_ message: String) {
        Task {
            do {
                isDownloadingGif = true
                errorMessage = nil
                
                // Create the message
                let cancelMessage = CancelMessage(message: message)
                generatedMessage = cancelMessage
                
                // If we have a selected GIF, download it
                if let gif = selectedGif {
                    let videoURL = try await giphyService.downloadVideo(gif)
                    shareItems = [cancelMessage.formattedMessage, videoURL]
                } else {
                    shareItems = [cancelMessage.formattedMessage]
                }
                
                showShareSheet = true
            } catch {
                errorMessage = "Failed to prepare message. Please try again."
            }
            isDownloadingGif = false
        }
    }
} 