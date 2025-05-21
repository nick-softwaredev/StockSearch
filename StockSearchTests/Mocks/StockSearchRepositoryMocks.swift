//
//  StockSearchRepositoryMcoks.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

@testable import StockSearch

struct MockStockSearchRepositorySuccess: StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> [Stock] {
        return [
            Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", averagePrice: 190.2),
            Stock(id: 2, name: "Tesla Inc.", ticker: "TSLA", averagePrice: 215.3)
        ]
    }
}

struct MockStockSearchRepositoryEmpty: StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> [Stock] {
        return []
    }
}

struct MockStockSearchRepositoryFailure: StockSearchRepositoryProtocol {
    enum SimulatedError: Error {
        case simulated
    }

    func getSearchableDataFor(query: String) async throws -> [Stock] {
        throw SimulatedError.simulated
    }
}
