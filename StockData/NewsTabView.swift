//
//  NewsTabView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/18/21.
//

import SwiftUI

struct NewsTabView: View {
    @ObservedObject var viewModel: ResponseViewModel
    
//    @State private var searchText = ""
    
//    var searchResults: [Stock] {
//        if searchText.isEmpty {
//            return stocks
//        } else {
//            return stocks.filter { $0.displayName.lowercased().contains(searchText.lowercased())
//                ||
//                $0.symbol.lowercased().contains(searchText.lowercased())
//            }
//        }
//        
//    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(
                text: error.localizedDescription,
                retryAction: refreshTask
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
    
    @Sendable
    private func refreshTask() {
        Task {
            await viewModel.refreshTask()
        }
    }
    
    @Sendable
    private func loadTask() async {
        await viewModel.loadArticles()
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
            
//            StockListView(stocks: searchResults) //
////                .task(loadTask)
//                .task(id: viewModel.fetchTaskToken, loadTask)
//                .overlay(overlayView)
//                .refreshable(action: refreshTask)
//                .navigationTitle("StockData")
            
            StockListView(stocks: stocks)
                .task(id: viewModel.fetchTaskToken, loadTask)
                .overlay(overlayView)
                .refreshable(action: refreshTask)
                .navigationTitle("StockData")


        }
        .navigationViewStyle(.stack)
        .searchable(text: $viewModel.searchQuery)
        .onChange(of: viewModel.searchQuery) { newValue in
            if newValue.isEmpty {
                viewModel.phase = .empty
                // Need to refresh the task when I clear out all search values
//                refreshTask()
                Task {
                    await loadTask()
                }
            }
        }
        .onSubmit(of: .search, search)
        
    }
}

struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTabView(
            viewModel: .init(
                fetch: { Welcome.previewData },
                search: { _ in Welcome.previewData }
            )
        )
    }
}
