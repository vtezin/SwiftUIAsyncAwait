//
//  SomeService.swift
//  SwiftUIAsyncAwait
//
//  Created by user on 25.12.2024.
//

import UIKit
import SwiftUI

enum LoadError: Error {
    case fetchFailed, decodeFailed
}

enum LoadingState {
    case idle
    case loading
    case loaded(Image)
    case failed(Error)
}

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: Image
}

@Observable final class ImageLoader {
    var state: LoadingState = .idle
    var images = [IdentifiableImage]()
    
    func loadImage(url: URL) async {
        state = .loading
        let result = await loadImageFromURL(url: url)
        switch result {
        case .success(let image):
            state = .loaded(image)
        case .failure(let error):
            state = .failed(error)
        }
    }
    
    func loadImagesСonsistently(urls: [URL]) async {
        state = .loading
        images.removeAll()
        
        for url in urls {
            let result = await loadImageFromURL(url: url)
            switch result {
            case .success(let image):
                images.append(IdentifiableImage(image: image))
            case .failure(let error):
                print("failure \(error)")
            }
        }
        
        state = .idle
    }
    
    func loadImagesParallel(urls: [URL]) async {
        state = .loading
        images.removeAll()
        
        for url in urls {
            async let result = loadImageFromURL(url: url)
            switch await result {
            case .success(let image):
                images.append(IdentifiableImage(image: image))
            case .failure(let error):
                print("failure \(error)")
            }
        }
        
        state = .idle
    }
    
    private func loadImageFromURL(url: URL) async -> Result<Image, Error> {
        try? await Task.sleep(for: .seconds(3))
        let downloadTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    return Image(uiImage: uiImage)
                } else {
                    throw LoadError.decodeFailed
                }
            } catch {
                throw LoadError.fetchFailed
            }
        }

        return await downloadTask.result
    }
}

extension ImageLoader {
    static let testURLS = [URL(string: "https://www.fund4dogs.ru/wp-content/uploads/2024/06/1000097411-1.jpg")!,
                           URL(string: "https://cs11.pikabu.ru/post_img/2019/02/04/12/1549312329147951618.jpg")!]
    
}