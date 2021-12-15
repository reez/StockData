//
//  StockDataApp.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import SwiftUI
// https://stock-data-yahoo-finance-alternative.p.rapidapi.com/v6/finance/quote?symbols=AAPL,GOOG,SQ,ETH
// https://rapidapi.com/principalapis/api/stock-data-yahoo-finance-alternative/

@main
struct StockDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: .init(
                    
                    fetch: { () -> [Stock] in
//                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        return Welcome.previewData
                    }
                    
//                    fetch: { () -> [Stock] in
//                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
//                        return try await StockDataAPI.live.fetch()
//                    }
                    
                )
            )
            
        }
    }
}
