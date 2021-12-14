//
//  ContentView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ResponseViewModel
    
    @Sendable
    private func loadTask() async {
        await viewModel.loadArticles()
    }
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Text(viewModel.stocks?.first?.displayName ?? "none")
        }
        .task(loadTask)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: .init(
                fetch: {
            Welcome.previewData
        }
            )
        )
    }
}
