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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Stock {
//    var priceChangeText: String {
//            let dub = regularMarketPrice - regularMarketOpen
//            let number = dub.asLocaleCurrency
//            let numberString = String(number)
//            return numberString
//    }
    
    var priceChangeText: String {
//            let dub = regularMarketPreviousClose - regularMarketPrice
        let dub = regularMarketPrice - regularMarketPreviousClose

            let number = dub.asLocaleCurrency
            let numberString = String(number)
            return numberString
    }
    
    var percentChangeText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 2
        // 173.12 -1.21 (-0.69%)
        // As of 01:57PM EST. Market open.
// open 175.11
        // prev day close 174.33
        // 173.12 (prev close) - 174.33 (current) = -1.21 is the difference
        // 1.21 ($ change) / 173.12 (close) = 0.00698937....   *100 and you get 0.69
        
//        let dub = regularMarketPreviousClose - regularMarketPrice // // 173.12 (current) - 174.33 (prev close) = -1.21 is the difference
        let dub = regularMarketPrice - regularMarketPreviousClose // // 173.12 (current) - 174.33 (prev close) = -1.21 is the difference

        let sup = dub / regularMarketPreviousClose
        let round = sup * 100
        
        let roundedValue = formatter.string(from: NSNumber.init(value: round))
        
        
        
        if let value = roundedValue {
            return String("\(value) %")

        } else {
            return String("")

        }
        
        
//        return String("\(roundedValue) %")
    }
    
    var lastText: String {
        return regularMarketPrice.asLocaleCurrency
    }
    
    var upOnly: Bool? {
//        if let honestLast = last, let honestOpen = datumOpen {
            let last = regularMarketPrice.asLocaleCurrency
            let close = regularMarketPreviousClose.asLocaleCurrency
            
            if last > close {
                return true
            } else if last < close {
                return false
            } else {
                return nil
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
