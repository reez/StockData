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
    @Published var phase = DataFetchPhase<[Result]>.empty
    @Published var stocks: [Result]? = nil
    
    let fetch: () async throws -> [Result]
    
    init(fetch: @escaping () async throws -> [Result]) {
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
