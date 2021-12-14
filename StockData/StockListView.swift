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
                
                VStack {
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stock.displayName)
                            Text(stock.symbol)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(stock.lastText)
                            HStack {
                                if let direction = stock.upOnly {
                                    direction ?
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .foregroundColor(.green)
                                    :
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .foregroundColor(.red)
                                }
                                Text(stock.priceChangeText)
                            }
                        }
                    }
             
                    
                }
                
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
