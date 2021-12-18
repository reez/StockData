//
//  SearchTabView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/18/21.
//

import SwiftUI

struct SearchTabView: View {
    @ObservedObject var viewModel: ArticleSearchViewModel
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
        case .empty:
//            ProgressView()
            if !viewModel.searchQuery.isEmpty {
                ProgressView()
            } else {
                EmptyPlaceholderView(
                    text: "Type your query to search from StockData",
                    image: Image(systemName: "bookmark")
                )
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(
                text: "No search results found",
                image: Image(systemName: "maginfyingglass")
            )
        case .failure(let error):
            RetryView(
                text: error.localizedDescription,
                retryAction: search
            )
        default:
            EmptyView()
        }
    }
    
    @Sendable
    private func search() {
        Task {
            await viewModel.searchArticle()
        }
    }
    
//    @Sendable
//    private func refreshTask() {
////        Task {
////            await viewModel.refreshTask()
////        }
//    }
    
    @Sendable
    private func loadTask() async {
        await viewModel.searchArticle()//.loadArticles()
    }
    
    private var stocks: [Stock] {
        if case let .success(stocks) = viewModel.phase {
            return stocks
        } else {
            return []
        }
    }
    var body: some View {
        
        NavigationView {
//
            StockListView(stocks: stocks)
////                .task(loadTask)
//                .task(id: viewModel.fetchTaskToken, loadTask)
                .overlay(overlayView)
//                .refreshable(action: refreshTask)
                .navigationTitle("Search")
//
        }
        .navigationViewStyle(.stack)
        .searchable(text: $viewModel.searchQuery)
        .onChange(of: viewModel.searchQuery) { newValue in
            if newValue.isEmpty {
                viewModel.phase = .empty
            }
        }
        .onSubmit(of: .search, search)
        
    }
}

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        
        SearchTabView(
            viewModel: .init(
                search: { _ in Welcome.previewData }
            )
        )
        
    }
}
