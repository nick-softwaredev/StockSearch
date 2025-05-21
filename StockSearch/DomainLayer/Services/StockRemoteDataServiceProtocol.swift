//
//  StockRemoteDataServiceProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

protocol StockRemoteDataServiceProtocol {
    func loadData(query: String) async throws -> (current: StockDataResponse, historical: StockDataResponse)
}
