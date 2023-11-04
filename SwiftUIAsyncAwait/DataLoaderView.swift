//
//  DataLoaderView.swift
//  SwiftUIAsyncAwait
//
//  Created by Vladimir Tezin on 03.11.2023.
//

import SwiftUI

struct DataLoaderView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = DataLoader()
    
    var body: some View {
        VStack (spacing: 100) {
            Button("Close view") {
                presentationMode.wrappedValue.dismiss()
            }
            
            VStack(spacing: 20) {
                Button("Load data") {
                    startLoading()
                }
                Text("viewModel.curState: \(viewModel.curState.rawValue)")
                Text("viewModel.loadedData: \(viewModel.loadedData)")
            }
        }
        .padding()
    }
    
    @MainActor
    private func startLoading() {
        Task {
            await viewModel.loadData()
        }
    }
}

struct DataLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        DataLoaderView()
    }
}
