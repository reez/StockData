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
            Text(viewModel.stocks?.first?.symbol ?? "none")
            Text(viewModel.stocks?.first?.lastText ?? "-")
            HStack {
                if let direction = viewModel.stocks?.first?.upOnly {
                    direction ?
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.green)
                    :
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(.red)
                }
                Text(viewModel.stocks?.first?.priceChangeText ?? "-")
            }

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
