//
//  Response.swift
//  StockData
//
//  Created by Matthew Ramsden on 12/14/21.
//

import Foundation

extension Double {
    var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true // don't have to set but just set to make sure
        formatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        formatter.locale = Locale.current

        let formattedString = formatter.string(from: self as NSNumber)
        return formattedString ?? "currency conversion fail" // figure out how to test and fail message
    }
}

struct ApiResponse: Decodable {
    let welcome: Welcome
 }

// MARK: - Welcome
struct Welcome: Codable {
    let quoteResponse: QuoteResponse
}

extension Welcome {

      static var previewData: [Stock] {
          let previewDataURL = Bundle.main.url(forResource: "response", withExtension: "json")!
          let data = try! Data(contentsOf: previewDataURL)

          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .iso8601

          let apiResponse = try! jsonDecoder.decode(Welcome.self, from: data)
          return apiResponse.quoteResponse.result //?? Welcome(pagination: Pagination(limit: 1, offset: 2, count: 3, total: 4), data: [])//[]
      }

  }

// MARK: - QuoteResponse
struct QuoteResponse: Codable {
    let result: [Stock]
    let error: JSONNull?
}

// MARK: - Result
struct Stock: Codable {
    let id = UUID()

    
    let language, region, quoteType, quoteSourceName: String
    let triggerable: Bool
    let currency, exchange, longName, messageBoardID: String
    let exchangeTimezoneName, exchangeTimezoneShortName: String
    let gmtOffSetMilliseconds: Int
    let market: String
    let esgPopulated: Bool
    let twoHundredDayAverageChange, twoHundredDayAverageChangePercent: Double
    let marketCap: Int
    let forwardPE, priceToBook: Double
    let earningsTimestamp, earningsTimestampStart, earningsTimestampEnd: Int?
    let trailingAnnualDividendRate: Double?
    let trailingPE: Double? // got coding keys not found for this one
    let trailingAnnualDividendYield: Double?
    let epsTrailingTwelveMonths, epsForward, epsCurrentYear, priceEpsCurrentYear: Double
    let sharesOutstanding: Int
    let bookValue, fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent: Double
    let twoHundredDayAverage: Double
    let sourceInterval, exchangeDataDelayedBy: Int
    let pageViewGrowthWeekly: Double
    let averageAnalystRating: String
    let tradeable: Bool
    let firstTradeDateMilliseconds, priceHint: Int
    let regularMarketChange, regularMarketChangePercent: Double
    let regularMarketTime: Int
    let regularMarketPrice, regularMarketDayHigh: Double
    let regularMarketDayRange: String
    let regularMarketDayLow: Double
    let regularMarketVolume: Int
    let regularMarketPreviousClose, bid, ask: Double
    let bidSize, askSize: Int
    let fullExchangeName, financialCurrency: String
    let regularMarketOpen: Double
    let averageDailyVolume3Month, averageDailyVolume10Day: Int
    let fiftyTwoWeekLowChange, fiftyTwoWeekLowChangePercent: Double
    let fiftyTwoWeekRange: String
    let fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh: Double
    let dividendDate: Int?
    let shortName, marketState, displayName, symbol: String
    let prevName, nameChangeDate: String?

    enum CodingKeys: String, CodingKey {
        case language, region, quoteType, quoteSourceName, triggerable, currency, exchange, longName
        case messageBoardID = "messageBoardId"
        case exchangeTimezoneName, exchangeTimezoneShortName, gmtOffSetMilliseconds, market, esgPopulated, twoHundredDayAverageChange, twoHundredDayAverageChangePercent, marketCap, forwardPE, priceToBook, earningsTimestamp, earningsTimestampStart, earningsTimestampEnd, trailingAnnualDividendRate, trailingPE, trailingAnnualDividendYield, epsTrailingTwelveMonths, epsForward, epsCurrentYear, priceEpsCurrentYear, sharesOutstanding, bookValue, fiftyDayAverage, fiftyDayAverageChange, fiftyDayAverageChangePercent, twoHundredDayAverage, sourceInterval, exchangeDataDelayedBy, pageViewGrowthWeekly, averageAnalystRating, tradeable, firstTradeDateMilliseconds, priceHint, regularMarketChange, regularMarketChangePercent, regularMarketTime, regularMarketPrice, regularMarketDayHigh, regularMarketDayRange, regularMarketDayLow, regularMarketVolume, regularMarketPreviousClose, bid, ask, bidSize, askSize, fullExchangeName, financialCurrency, regularMarketOpen, averageDailyVolume3Month, averageDailyVolume10Day, fiftyTwoWeekLowChange, fiftyTwoWeekLowChangePercent, fiftyTwoWeekRange, fiftyTwoWeekHighChange, fiftyTwoWeekHighChangePercent, fiftyTwoWeekLow, fiftyTwoWeekHigh, dividendDate, shortName, marketState, displayName, symbol, prevName, nameChangeDate
    }
}

extension Stock: Identifiable {}


extension Stock {
    var priceChangeText: String {
            let dub = regularMarketPrice - regularMarketOpen
            let number = dub.asLocaleCurrency
            let numberString = String(number)
            return numberString
    }
    
    var lastText: String {
//        if let honestLast = last {
            return regularMarketPrice.asLocaleCurrency//String(honestLast)
//        } else {
//            return "No last price"
//        }
    }
    
    var upOnly: Bool? {
//        if let honestLast = last, let honestOpen = datumOpen {
            let last = regularMarketPrice.asLocaleCurrency
            let open = regularMarketOpen.asLocaleCurrency
            
            if last > open {
                return true
            } else {
                return false
            }
            
//            return //honestLast.asLocaleCurrency//String(honestLast)
//        } else {
//            return nil//"No last price"
//        }
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
