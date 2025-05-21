//
//  StockLocalDataServiceProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/21/25.
//

import Foundation

protocol StockLocalDataServiceProtocol {
    func getCachedData() -> [StockDataEntry]?
    func setCache(_ data: [StockDataEntry])
}
