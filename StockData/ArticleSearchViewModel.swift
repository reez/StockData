//
//  ArticleSearchViewModel.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/18/21.
//

import SwiftUI

class ArticleSearchViewModel: ObservableObject {

    @Published var phase: DataFetchPhase<[Stock]> = .empty
    @Published var searchQuery = ""

    let search: (String) async throws -> [Stock]

    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(search: @escaping (String) async throws -> [Stock]) {
        self.search = search
    }
    
    @MainActor
    func searchArticle() async {
        if Task.isCancelled { return }
        
        let searchQuery = trimmedSearchQuery
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await self.search(searchQuery)
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .failure(error)
        }
    }
    
}
