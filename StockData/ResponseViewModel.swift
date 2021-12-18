//
//  ResponseViewModel.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import Foundation

enum DataFetchPhase<T: Equatable>{

    case empty
    case success(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        }
//        else if case .fetchingNextPage(let value) = self {
//            return value
//        }
        return nil
    }
}

//extension DataFetchPhase: Equatable {}

struct FetchTaskToken: Equatable {
//    var category: Category
    var token: Date
}

class ResponseViewModel: ObservableObject {
    @Published var phase = DataFetchPhase<[Stock]>.empty
    @Published var stocks: [Stock]? = nil
    @Published var fetchTaskToken: FetchTaskToken = FetchTaskToken(token: Date())

    let fetch: () async throws -> [Stock]
    private let cache = DiskCache<[Stock]>(filename: "stockdata_articles", expirationInterval: 3 * 60)

    init(fetch: @escaping () async throws -> [Stock]) {
        self.fetch = fetch
        Task(priority: .userInitiated) {
             try? await cache.loadFromDisk()
         }
    }
    
    func refreshTask() async {
        fetchTaskToken.token = Date()
        await cache.removeValue(forKey: "category")
//        await loadArticles()
    }
    
    @MainActor
    func loadArticles() async {
        self.stocks = nil
        if Task.isCancelled { return }
        if let articles = await cache.value(forKey: "category") { // hardcode category because i dont need
              phase = .success(articles)
              print("CACHE HIT")
            return
          }
        print("CACHE MISSED/EXPIRED")
        do {
            let articles = try await self.fetch()
            if Task.isCancelled { return }
            await cache.setValue(articles, forKey: "category")
            try? await cache.saveToDisk()
            print("CACHE SET")
            phase = .success(articles)
            self.stocks = articles
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }
    
}
