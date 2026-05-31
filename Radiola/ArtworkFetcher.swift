//
//  ArtworkFetcher.swift
//  Radiola
//

import AppKit
import Combine
import Foundation

@MainActor
class ArtworkFetcher: ObservableObject {
    static let shared = ArtworkFetcher()

    @Published var artworkImage: NSImage? = nil

    private var fetchTask: Task<Void, Never>?

    private init() {}

    /* ****************************************
     *
     * ****************************************/
    func fetch(for songTitle: String) {
        fetchTask?.cancel()
        fetchTask = Task {
            guard let url = iTunesURL(for: songTitle) else {
                artworkImage = nil
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }
                guard
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let results = json["results"] as? [[String: Any]],
                    let first = results.first,
                    let artworkUrl100 = first["artworkUrl100"] as? String
                else {
                    artworkImage = nil
                    return
                }
                let highResUrl = artworkUrl100.replacingOccurrences(of: "100x100bb", with: "600x600bb")
                guard let imageURL = URL(string: highResUrl) else {
                    artworkImage = nil
                    return
                }
                let (imageData, _) = try await URLSession.shared.data(from: imageURL)
                guard !Task.isCancelled else { return }
                artworkImage = NSImage(data: imageData)
            } catch {
                if !Task.isCancelled {
                    artworkImage = nil
                }
            }
        }
    }

    /* ****************************************
     *
     * ****************************************/
    func clear() {
        fetchTask?.cancel()
        fetchTask = nil
        artworkImage = nil
    }

    /* ****************************************
     *
     * ****************************************/
    func iTunesURL(for songTitle: String) -> URL? {
        let parts = songTitle.components(separatedBy: " - ")
        guard parts.count >= 2 else { return nil }
        let artist = parts[0].trimmingCharacters(in: .whitespaces)
        let title = parts[1...].joined(separator: " - ").trimmingCharacters(in: .whitespaces)
        guard !artist.isEmpty, !title.isEmpty else { return nil }
        let query = "\(artist) \(title)"
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "https://itunes.apple.com/search?term=\(encoded)&media=music&limit=1")
    }
}
