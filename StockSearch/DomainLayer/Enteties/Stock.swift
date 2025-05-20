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
    let averagePrice: Double
}

extension Stock {
    static let mockAAPL = Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", averagePrice: 205.5)
    static let mockGOOG = Stock(id: 2, name: "Alphabet Inc.", ticker: "GOOG", averagePrice: 2800.0)
    static let mockTSLA = Stock(id: 3, name: "Tesla, Inc.", ticker: "TSLA", averagePrice: 710.0)

    static let mockList: [Stock] = [
        .mockAAPL,
        .mockGOOG,
        .mockTSLA
    ]
}
