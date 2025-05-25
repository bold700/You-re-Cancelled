import Foundation
import UIKit

actor GiphyService {
    private let apiKey = "GlVGYHkr3WSBnllca54iNt0yFbjz7L65"
    private let baseURL = "https://api.giphy.com/v1/gifs"
    private var currentOffset: [String: Int] = [:]
    private let gifsPerPage = 25
    
    struct GiphyResponse: Codable {
        let data: [GiphyGif]
        let pagination: Pagination
        
        struct Pagination: Codable {
            let totalCount: Int
            let count: Int
            let offset: Int
            
            enum CodingKeys: String, CodingKey {
                case totalCount = "total_count"
                case count
                case offset
            }
        }
    }
    
    struct GiphyGif: Codable, Identifiable {
        let id: String
        let title: String
        let images: Images
        
        struct Images: Codable {
            let original: ImageData
            let fixedWidth: ImageData
            
            enum CodingKeys: String, CodingKey {
                case original
                case fixedWidth = "fixed_width"
            }
        }
        
        struct ImageData: Codable {
            let url: String
            let mp4: String?
            let width: String
            let height: String
        }
    }
    
    func searchGifs(for query: String, loadMore: Bool = false) async throws -> [GiphyGif] {
        if loadMore {
            // Update offset met een random waarde voor meer variatie
            let currentTotal = try await getTotalCount(for: query)
            let maxOffset = max(0, currentTotal - gifsPerPage)
            currentOffset[query] = Int.random(in: 0...maxOffset)
        } else {
            // Start met een random offset
            let currentTotal = try await getTotalCount(for: query)
            let maxOffset = max(0, currentTotal - gifsPerPage)
            currentOffset[query] = Int.random(in: 0...min(maxOffset, 100))
        }
        
        let response = try await search(term: query, offset: currentOffset[query] ?? 0)
        return response.data
    }
    
    private func getTotalCount(for searchTerm: String) async throws -> Int {
        let results = try await search(term: searchTerm, offset: 0, limit: 1)
        return results.pagination.totalCount
    }
    
    func downloadVideo(_ gif: GiphyGif) async throws -> URL {
        guard let mp4String = gif.images.fixedWidth.mp4,
              let url = URL(string: mp4String) else {
            throw NSError(domain: "GiphyService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid MP4 URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Save video temporarily
        let tempDir = FileManager.default.temporaryDirectory
        let videoURL = tempDir.appendingPathComponent("\(gif.id).mp4")
        try data.write(to: videoURL)
        return videoURL
    }
    
    private func search(term: String, offset: Int, limit: Int? = nil) async throws -> GiphyResponse {
        var components = URLComponents(string: "\(baseURL)/search")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: term),
            URLQueryItem(name: "limit", value: "\(limit ?? gifsPerPage)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "rating", value: "g"),
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "bundle", value: "messaging_non_clips")
        ]
        
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(GiphyResponse.self, from: data)
    }
} 