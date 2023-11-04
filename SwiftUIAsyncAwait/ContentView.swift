//
//  ContentView.swift
//  SwiftUIAsyncAwait
//
//  Created by Vladimir Tezin on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showDataLoader = false
    
    var body: some View {
        VStack {
            Button("Show data loader") {
                showDataLoader = true
            }
        }
        .padding()
        .sheet(isPresented: $showDataLoader) {
            DataLoaderView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
