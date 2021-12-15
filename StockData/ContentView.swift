//
//  ContentView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ResponseViewModel
    
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
                retryAction: {}//refreshTask
            )
        default:
            EmptyView()
        }
    }
    
    @Sendable
    private func loadTask() async {
        await viewModel.loadArticles()
    }
    
    private var stocks: [Result] {
        if case let .success(stocks) = viewModel.phase {
            return stocks
        } else {
            return []
        }
    }
    
    var body: some View {
//        StockListView(stocks: viewModel.stocks ?? [])
        StockListView(stocks: stocks)
            .task(loadTask)
            .overlay(overlayView)

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: .init(
                fetch: { Welcome.previewData }
            )
        )
    }
}
