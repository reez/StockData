//
//  ContentView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {

        TabView {
            
            NewsTabView(
                viewModel: .init(
                    fetch: { () -> [Stock] in
//                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        return try await StockDataAPI.live.fetch()
//                        return Welcome.previewData
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
        ContentView()
    }
}
