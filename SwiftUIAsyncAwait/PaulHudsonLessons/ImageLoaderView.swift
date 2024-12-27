//
//  ImageLoaderView.swift
//  SwiftUIAsyncAwait
//
//  Created by user on 25.12.2024.
//

import SwiftUI

struct ImageLoaderView: View {
    @State private var imageLoader = ImageLoader()
    
    var body: some View {
        List {
            if imageLoader.inProgress {
                ProgressView("Loading...")
            }
            
            ForEach(imageLoader.images) { image in
                image.image
                    .resizable()
                    .scaledToFit()
            }
            Button("Load consistently") {
                Task {
                    await imageLoader.loadImagesСonsistently(urls: ImageLoader.testURLS)
                }
            }
            
            Button("Load parallel") {
                Task {
                    await imageLoader.loadImagesParallel(urls: ImageLoader.testURLS)
                }
            }
        }
    }
}

#Preview {
    ImageLoaderView()
}
