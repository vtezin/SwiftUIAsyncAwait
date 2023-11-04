//
//  DataLoader.swift
//  SwiftUIAsyncAwait
//
//  Created by Vladimir Tezin on 04.11.2023.
//

import SwiftUI

class DataLoader: ObservableObject {
    @Published var curState: State = .inited
    @Published var loadedData: Int = 0
    
    enum State: String {
        case inited
        case loading
        case complete
    }
    
    deinit {
        print("DataLoader deinit")
    }
    
    @MainActor
    func loadData() async {
        curState = .loading
        loadedData = 0
        Task { [weak self] in
            guard let self = self else { return }
            
            let bigData = await getBigData()
            loadedData = bigData
            curState = .complete
        }
    }
    
    private func getBigData() async -> Int {
        var counter = 0
        for i in 1...20_000_000 {
            counter = counter + i
        }
        return counter
    }
}
