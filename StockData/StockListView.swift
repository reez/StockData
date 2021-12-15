//
//  StockListView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct StockListView: View {
    let stocks: [Stock]
    
    @State private var searchText = ""
    
    var searchResults: [Stock] {
        
//        let display = !stocks.filter { $0.displayName.contains(searchText) }.isEmpty
//        let symbol = !stocks.filter { $0.symbol.contains(searchText) }.isEmpty
//        let displayResults = stocks.filter { $0.displayName.contains(searchText) }
//        let symbolResults = stocks.filter { $0.symbol.contains(searchText) }
//
//        
//        if searchText.isEmpty {
//            return stocks
//        }
//        else if display
//        {
//            return displayResults
//        }
//        else if symbol {
//            return symbolResults
//        }
//        else {
//            return stocks
////                .filter {
////                    $0.displayName.contains(
////                        searchText
////                    )
////                }
//        }
        
        
            if searchText.isEmpty {
                return stocks
            } else {
                return stocks.filter { $0.displayName.contains(searchText) }
            }
        
        
        
        
    }

    
    var body: some View {
        
        List {
            ForEach(searchResults) { stock in // stocks
                StockRowView(stock: stock)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Look for something")
    }
    
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView(stocks: Welcome.previewData)
    }
}
