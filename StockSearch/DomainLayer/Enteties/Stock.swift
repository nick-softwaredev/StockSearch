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
