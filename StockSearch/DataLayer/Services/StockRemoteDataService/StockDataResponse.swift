//
//  StockDataResponse.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

struct StockDataResponse: Decodable {
    let stocks: [StockDataEntry]
}

struct StockDataEntry: Decodable, Equatable {
    let id: Int
    let name: String
    let ticker: String
    let currentPrice: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ticker
        case currentPrice = "current_price"
    }
}
