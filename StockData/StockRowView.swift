//
//  StockRowView.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI

struct StockRowView: View {
    let stock: Stock
    
    var body: some View {
        
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
                        Text(stock.percentChangeText)
                    }
                }
            }
     
        }
        
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(stock: Welcome.previewData.first!)
    }
}
