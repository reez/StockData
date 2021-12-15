//
//  ResponseViewModel.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import Foundation

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

class ResponseViewModel: ObservableObject {
    @Published var phase = DataFetchPhase<[Stock]>.empty
    @Published var stocks: [Stock]? = nil
    
    let fetch: () async throws -> [Stock]
    
    init(fetch: @escaping () async throws -> [Stock]) {
        self.fetch = fetch
    }
    
    func refreshTask() async {
        //fetchTaskToken.token = Date()
        await loadArticles()
    }
    
    @MainActor
    func loadArticles() async {
        self.stocks = nil
        if Task.isCancelled { return }
        do {
            let articles = try await self.fetch()
            if Task.isCancelled { return }
            phase = .success(articles)
            self.stocks = articles
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }
    
}
