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

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: Image
}

@Observable final class ImageLoader {
    var inProgress = false
    var images = [IdentifiableImage]()
    
    func loadImagesСonsistently(urls: [URL]) async {
        inProgress = true
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
        
        inProgress = false
    }
    
    func loadImagesParallel(urls: [URL]) async {
        inProgress = true
        images.removeAll()
        
        for url in urls {
            Task {
                let result = await self.loadImageFromURL(url: url)
                switch result {
                case .success(let image):
                    self.images.append(IdentifiableImage(image: image))
                case .failure(let error):
                    print("failure \(error)")
                }
                if self.images.count == urls.count {
                    self.inProgress = false
                }
            }
        }
    }
    
    private func loadImageFromURL(url: URL, sleepSeconds: Int = 2) async -> Result<Image, Error> {
        try? await Task.sleep(for: .seconds(sleepSeconds))
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
