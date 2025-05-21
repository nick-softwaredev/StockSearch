//
//  Stock.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

struct Stock: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    let ticker: String
    let currentPrice: Double
    let averagePrice: Double
}

extension Stock {
    static let mockAAPL = Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", currentPrice: 200, averagePrice: 205.5)
    static let mockGOOG = Stock(id: 2, name: "Alphabet Inc.", ticker: "GOOG", currentPrice: 2600, averagePrice: 2800.0)
    static let mockTSLA = Stock(id: 3, name: "Tesla, Inc.", ticker: "TSLA", currentPrice: 700, averagePrice: 710.0)

    static let mockList: [Stock] = [
        .mockAAPL,
        .mockGOOG,
        .mockTSLA
    ]
}
