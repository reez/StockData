//
//  StockDataAPI.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import Foundation

struct StockDataAPI {
    let fetch: () async throws -> [Stock]
    private init(fetch: @escaping () async throws -> [Stock]) {
        self.fetch = fetch
    }
}

extension StockDataAPI {
    static let live = Self(
        fetch: { try await fetchArticles(from: generateNewsURL()) }
    )
}

extension StockDataAPI {
    static let mock = Self(
        fetch: { Welcome.previewData }
    )
}

private enum ApiKey: String {
    case gmail = "e068f43517d5126e52e3793c7c85b19d" // works
//    case outlook = "5c35233da22d0845408b490f0808b8e6" // over monthly limit
//    case hey = "511160e3854cf17c626f60b87f22eb0b" // deleted
}

func generateNewsURL() -> URL {
    // https://stock-data-yahoo-finance-alternative.p.rapidapi.com/v6/finance/quote?symbols=AAPL,GOOG,SQ
    let url = "https://stock-data-yahoo-finance-alternative.p.rapidapi.com/v6/finance/quote?symbols=AAPL,GOOG,SQ"//"https://api.marketstack.com/v1/intraday/latest?"
//    url += "access_key=\(ApiKey.gmail.rawValue)"
//    url += "&symbols=AAPL,GOOG,SQ"
    return URL(string: url)!
}

private func generateError(code: Int = 1, description: String) -> Error {
    NSError(domain: "StocksAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
}

private func fetchArticles(from url: URL) async throws -> [Stock] {
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    var request = URLRequest(url: url)
    request.addValue("stock-data-yahoo-finance-alternative.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
    request.addValue("2bcc6a8c92msh438108b00055e06p1f0973jsn1eef7f39f756", forHTTPHeaderField: "x-rapidapi-key")
    request.httpMethod = "GET"

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let response = response as? HTTPURLResponse else {
        throw generateError(description: "Bad Response")
    }

    switch response.statusCode {
        
    case (200...299):
        let apiResponse = try jsonDecoder.decode(Welcome.self, from: data)
        return apiResponse.quoteResponse.result
        
    case (401):
        throw generateError(description: "Access key error.")
        
    case (429):
        throw generateError(description: "Your monthly usage limit has been reached. Please upgrade your Subscription Plan.")
        
    default:
        throw generateError(description: "A server error occured")
        
    }
}
