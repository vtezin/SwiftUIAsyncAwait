//
//  ImageLoaderView.swift
//  SwiftUIAsyncAwait
//
//  Created by user on 25.12.2024.
//

import SwiftUI

struct ImageLoaderView: View {
    @State private var imageLoader = ImageLoader()
    @State private var counter = 0
    
    var body: some View {
        List {
            Button("\(counter)") {
                counter += 1
            }
            
            if imageLoader.inProgress {
                HStack {
                    ProgressView()
                    Spacer()
                    Text("\(imageLoader.images.count) loaded")
                }
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
