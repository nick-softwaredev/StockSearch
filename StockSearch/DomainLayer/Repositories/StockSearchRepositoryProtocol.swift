//
//  StockSearchRepositoryProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

protocol StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> ([Stock])
}

struct StockSearchRepositoryProtocol_Preview: StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> ([Stock]) {
        return StockSearchHelper.search(query: query, mergedStockData: Stock.mockList, resultLimit: 10)
    }
}
