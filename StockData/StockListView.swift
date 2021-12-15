//
//  StockListView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct StockListView: View {
    let stocks: [Result]
    
    var body: some View {
        
        List {
            ForEach(stocks) { stock in
                StockRowView(stock: stock)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        
    }
    
}

struct StockListView_Previews: PreviewProvider {
    static var previews: some View {
        StockListView(stocks: Welcome.previewData)
    }
}
