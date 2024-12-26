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
            Section("Single image") {
                switch imageLoader.state {
                case .idle:
                    Text("Idle")
                case .loading:
                    ProgressView()
                case .loaded(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failed(let error):
                    Text("Error: \(error)")
                }
                
                Button("Load") {
                    Task {
                        await imageLoader.loadImage(url: ImageLoader.testURLS.first!)
                    }
                }
            }
            
            
            Section("Multiple images") {
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
}

#Preview {
    ImageLoaderView()
}
