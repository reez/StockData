//
//  ContentView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    //    @ObservedObject var viewModel: ResponseViewModel
    //
    //    @ViewBuilder
    //    private var overlayView: some View {
    //        switch viewModel.phase {
    //        case .empty:
    //            ProgressView()
    //        case .success(let articles) where articles.isEmpty:
    //            EmptyPlaceholderView(text: "No Articles", image: nil)
    //        case .failure(let error):
    //            RetryView(
    //                text: error.localizedDescription,
    //                retryAction: refreshTask
    //            )
    //        default:
    //            EmptyView()
    //        }
    //    }
    //
    //    @Sendable
    //    private func refreshTask() {
    //        Task {
    //            await viewModel.refreshTask()
    //        }
    //    }
    //
    //    @Sendable
    //    private func loadTask() async {
    //        await viewModel.loadArticles()
    //    }
    //
    //    private var stocks: [Stock] {
    //        if case let .success(stocks) = viewModel.phase {
    //            return stocks
    //        } else {
    //            return []
    //        }
    //    }
    
    var body: some View {
        
        //        NavigationView {
        //
        //            StockListView(stocks: stocks)
        ////                .task(loadTask)
        //                .task(id: viewModel.fetchTaskToken, loadTask)
        //                .overlay(overlayView)
        //                .refreshable(action: refreshTask)
        //                .navigationTitle("StockData")
        //
        //        }
        //        .navigationViewStyle(.stack)
        
        
        TabView {
            
            NewsTabView(
                viewModel: .init(
                    fetch: { () -> [Stock] in
//                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        //return try await StockDataAPI.live.fetch()
                        return Welcome.previewData
                    }
                )
            )
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            
            SearchTabView(
                viewModel: .init(
                    search: { query in
                        try await StockDataAPI.live.search(query)
                    }
                )
            )
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
//            viewModel: .init(
//                fetch: { Welcome.previewData }
//            )
        )
    }
}
