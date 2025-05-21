//
//  StockRemoteDataServiceProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

protocol StockRemoteDataServiceProtocol {
    func loadCurrentDataFor(query: String) async throws -> StockDataResponse
    func loadHistoricDataFor(query: String) async throws -> StockDataResponse
}
